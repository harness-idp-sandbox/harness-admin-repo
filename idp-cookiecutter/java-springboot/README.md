# 🍪 Cookiecutter Spring Boot Template

A reusable [Cookiecutter](https://cookiecutter.readthedocs.io) template for bootstrapping a **Spring Boot microservice** with modern CI/CD and deployment support.

---

## 🚀 Features

- **Java 17 + Spring Boot 2.7.x**
- **Maven** build system  
- **Dockerfile** for containerized builds (`buildx`-ready for EKS)  
- **Kubernetes manifests** (`Deployment` + `Service`) for EKS  
- Sample endpoints: `/api`, `/health`, `/swagger-ui.html`, `/actuator/info`  
- Built-in Harness IDP compatibility

---

## 🧰 Prerequisites

Make sure you have:

- [Python 3.8+](https://www.python.org/downloads/)
- [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html)
- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) connected to your EKS cluster

---

## 🏗️ Generate Your Project

Install Cookiecutter:

```bash
pip install cookiecutter
```

Then generate your new app from this template:

```bash
cookiecutter gh:harness-idp-sandbox/java-app-with-k8s-deploy-harnesscicd
```

You’ll be prompted for variables like:

- `project_name`
- `project_slug`
- `package_name`
- `group_id`
- `docker_registry`
- `k8s_namespace`

---

## 🧭 Next Steps

1. `cd <your-project-name>`  
2. Review the generated `README.md` for build and deploy steps  
3. Run locally or push to EKS using the pre-built manifests

Example:

```bash
mvn clean package -DskipTests
docker buildx build --platform linux/amd64 -t <your-registry>/<your-app>:latest --push .
kubectl apply -f kubernetes/
```

---

## 📝 License

© Harness SE Team — for internal and proof-of-value (PoV) use.
