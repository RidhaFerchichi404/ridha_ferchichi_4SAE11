# Use an official OpenJDK runtime as a parent image
FROM eclipse-temurin:17-jdk

# Set working directory inside container
WORKDIR /app

# Copy the built JAR file from the Jenkins workspace into the container
COPY target/student-management.jar /app/student-management.jar

# Expose port (change if your app uses a different one)
EXPOSE 8089

# Run the application very well
ENTRYPOINT ["java", "-jar", "/app/student-management.jar"]
