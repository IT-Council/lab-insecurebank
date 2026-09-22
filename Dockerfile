FROM maven:3.9-eclipse-temurin-8 AS builder

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

RUN find /app/target -type f -name "*.war" -print

FROM tomcat:8.5-jdk8

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/insecure-bank.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
