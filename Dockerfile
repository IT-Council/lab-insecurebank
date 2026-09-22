# =========================
# Build the application
# =========================
FROM maven:3.9-eclipse-temurin-8 AS builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


# =========================
# Run Tomcat
# =========================
FROM openjdk:8-jdk-alpine

WORKDIR /usr/local/tomcat

RUN wget --no-check-certificate \
    https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz \
    && tar xvfz apache-tomcat-8.5.73.tar.gz \
    && mv apache-tomcat-8.5.73/* /usr/local/tomcat/ \
    && rm -rf apache-tomcat-8.5.73.tar.gz

COPY --from=builder /app/target/insecure-bank.war \
    /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["./bin/catalina.sh", "run"]
