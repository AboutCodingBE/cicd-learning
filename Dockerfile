FROM openjdk:21-jdk-slim AS build

# Copy the built jar file into the image
COPY target/*.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]