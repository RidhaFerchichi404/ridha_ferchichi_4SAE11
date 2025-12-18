# Use an official OpenJDK runtime as a parent image
FROM eclipse-temurin:17-jdk

# Set working directory inside container
WORKDIR /app

# Copy the built JAR file from the Jenkins workspace into the container
COPY target/student-management-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose port 8080 (standard Spring Boot port for Kubernetes)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8080"]
