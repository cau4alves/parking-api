FROM eclipse-temurin:21-jdk-alpine AS build

# Define o diretório de trabalho dentro do container
WORKDIR /app

COPY pom.xml .
COPY src src

RUN ./mvnw clean package -DskipTests

# Estágio de Produção (Imagem menor e mais segura)
FROM eclipse-temurin:21-jre-alpine

# Expõe a porta que o Spring Boot usa (padrão é 8080)
EXPOSE 8080

COPY --from=build /app/target/estacionamento-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]