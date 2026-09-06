FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

COPY .mvn/ /app/.mvn

COPY mvnw pom.xml /app/

COPY src/ /app/src

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

####------ Stage 1 ----- #######

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]