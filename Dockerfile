FROM adoptopenjdk/openjdk11:jre-11.0.6_10-alpine

EXPOSE 8081

RUN addgroup -S spring && adduser -S spring -G spring

USER spring:spring

COPY target/springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war

ENTRYPOINT ["java","-jar","/springboot-crud-restful-webservices-0.0.1-SNAPSHOT.war"]