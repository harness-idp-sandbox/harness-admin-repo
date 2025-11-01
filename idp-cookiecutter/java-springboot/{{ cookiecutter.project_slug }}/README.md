# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

---

## ⚡️ What you get

- Spring Boot 2.7.x (Java 11) web app
- Clean landing page at `/` (static `index.html`)
- JSON API at `/api` and health at `/health`
- Swagger UI at `/swagger-ui.html`
- Build & commit metadata at `/actuator/info`
- Kubernetes manifests (Deployment + Service) ready for EKS
- Docker image that runs on Linux/amd64

---

## 🧰 Prereqs

- JDK 11
- Maven 3.8+
- Docker (with `buildx`)
- kubectl connected to a cluster (EKS or compatible)

---

## 🚀 Build & Run Locally

```bash
# build jar
mvn clean package -DskipTests

# run app
java -jar target/{{ cookiecutter.artifact_id }}-{{ cookiecutter.version }}.jar

# open in browser
open http://localhost:8080/
```

Endpoints:
- `GET /` → landing page
- `GET /api` → sample JSON
- `GET /health` → health JSON
- `GET /swagger-ui.html` → API docs
- `GET /actuator/info` → build & commit metadata

---

## 🐳 Build & Push Docker Image

The runtime image expects the fat jar to be present (built with the command above). The Dockerfile copies the jar and runs `java -jar`.

```bash
# build & push for EKS (linux/amd64)
docker buildx build   --platform linux/amd64   -t {{ cookiecutter.docker_registry }}/{ cookiecutter.docker_image_name }}:latest   --push .
```

> Tip: If you’re using a private registry, make sure your cluster has the right imagePullSecret.

---

## ☸️ Deploy to Kubernetes (EKS)

```bash
# namespace (templated)
kubectl get ns {{ cookiecutter.k8s_namespace }} >/dev/null 2>&1 || kubectl create ns {{ cookiecutter.k8s_namespace }}

# apply manifests
kubectl apply -f kubernetes/service.yml
kubectl apply -f kubernetes/deployment.yml

# watch rollout
kubectl rollout status deploy/{ cookiecutter.artifact_id }} -n {{ cookiecutter.k8s_namespace }}

# get external endpoint
kubectl get svc {{ cookiecutter.artifact_id }}-svc -n {{ cookiecutter.k8s_namespace }}
```

When the `EXTERNAL-IP` is ready, open:
```
http://<EXTERNAL-IP>/
```

If you’re in a cluster without external LoadBalancers, port-forward instead:
```bash
kubectl port-forward svc/{{ cookiecutter.artifact_id }}-svc 8080:80 -n {{ cookiecutter.k8s_namespace }}
# then visit http://localhost:8080/
```

---

## 🔁 Fast Dev Loop

This repo ships with `:latest` and `imagePullPolicy: Always`, so you don’t need to edit YAML on each build. After pushing a new image, just restart the deployment:

```bash
docker buildx build --platform linux/amd64 -t {{ cookiecutter.docker_registry }/{ cookiecutter.docker_image_name }}:latest --push .

kubectl rollout restart deploy/{ cookiecutter.artifact_id }} -n {{ cookiecutter.k8s_namespace }}
kubectl rollout status deploy/{ cookiecutter.artifact_id }} -n {{ cookiecutter.k8s_namespace }}
```

---

## ⚙️ Configuration

`src/main/resources/application.properties`:
```properties
server.port=8080
management.endpoints.web.exposure.include=health,info
management.info.git.mode=full
info.app.name={ cookiecutter.package_name }
info.app.description={ cookiecutter.description }
```

Env vars used by the container (set in the Deployment):
- `JAVA_OPTS` → JVM container tuning (defaults to `-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0`)
- `POD_NAME`, `POD_NAMESPACE` → auto-injected via Downward API (used in the sample response)

---

## 🧪 Tests

```bash
mvn test
```

`AppTest` includes:
- Spring context load smoke test
- `/api` JSON contract
- `/health` contract

---

## 📦 Project Layout

```
{{ cookiecutter.project_slug }}/
├─ src/
│  ├─ main/
│  │  ├─ java/{{ cookiecutter.package_path }}/
│  │  │  ├─ App.java
│  │  │  └─ HelloController.java
│  │  └─ resources/
│  │     └─ static/
│  │        └─ index.html
│  └─ test/
│     └─ java/{{ cookiecutter.package_path }}/AppTest.java
├─ kubernetes/
│  ├─ deployment.yml
│  └─ service.yml
├─ Dockerfile
└─ pom.xml
```

---

## 🧭 Troubleshooting

- **Image pulls but pod crashes** → check `kubectl logs` and verify the jar path is `/app/app.jar` inside the image.
- **`exec format error`** on startup → your image arch doesn’t match node arch. Build with `--platform linux/amd64` for EKS x86 nodes.
- **`/` shows Whitelabel error** → ensure `src/main/resources/static/index.html` exists in the jar (`jar tf target/*.jar | grep BOOT-INF/classes/static/index.html`).
- **Changes don’t show up** → you pushed `:latest` but Pods reused the cached image. Use `imagePullPolicy: Always` (already set) and `kubectl rollout restart`.

---

## 📝 License

© {{ cookiecutter.author_name }}. For demo/PoV purposes.
