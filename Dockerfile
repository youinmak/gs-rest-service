# syntax=docker/dockerfile:1

# Build stage
FROM eclipse-temurin:25-jdk-jammy AS builder
WORKDIR /app

# Copy the Java complete project and build an executable jar
COPY complete ./complete
WORKDIR /app/complete
RUN chmod +x mvnw && ./mvnw -q -Dmaven.test.skip=true package

# Runtime stage
FROM eclipse-temurin:25-jre-jammy
WORKDIR /app

# Copy the packaged Spring Boot jar from the builder image
COPY --from=builder /app/complete/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
