# Dockerfile
FROM eclipse-temurin:11-jre
WORKDIR /app
# copy the fat jar produced by mvn package
COPY target/*-SNAPSHOT.jar /app/app.jar
# if you use a fixed version tag in cookiecutter, you can COPY target/{{cookiecutter.artifact_id}}-{{cookiecutter.version}}.jar app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["java","-jar","/app/app.jar"]
