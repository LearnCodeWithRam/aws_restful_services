# Use an official OpenJDK 17 runtime as a parent image
FROM adoptopenjdk/openjdk17:jdk-17.0.2_8-alpine

# Expose port 8081
EXPOSE 8081

# Add a non-root user to run the application
RUN addgroup -S spring && adduser -S spring -G spring

# Switch to the non-root user
USER spring:spring

# Copy the application war file to the container
COPY target/springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war /springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war

# Command to run the application
ENTRYPOINT ["java", "-jar", "/springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war"]
