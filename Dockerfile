# Estágio de Build (Baseado no JDK para compilar)
FROM eclipse-temurin:21-jdk-alpine AS build

# Define o diretório de trabalho dentro do container
WORKDIR /app

# COPIA OS ARQUIVOS ESSENCIAIS PARA O BUILD:
COPY pom.xml .
COPY src src
# Adicionando o Maven Wrapper e a pasta de configuração (.mvn)
COPY mvnw .
COPY .mvn .mvn

# APLICA PERMISSÃO DE EXECUÇÃO ao script do Maven Wrapper (essencial no Linux)
RUN chmod +x ./mvnw

# Comando de Build para gerar o JAR
RUN ./mvnw clean package -DskipTests

# Estágio de Produção (Imagem menor e mais segura, baseada apenas no JRE)
FROM eclipse-temurin:21-jre-alpine

# Expõe a porta que o Spring Boot usa (padrão é 8080)
EXPOSE 8080

# Copia o JAR do estágio de build para a imagem final
# O caminho está correto para o nome do seu artefato
COPY --from=build /app/target/estacionamento-0.0.1-SNAPSHOT.jar app.jar

# Define o ponto de entrada para executar a aplicação
ENTRYPOINT ["java", "-jar", "/app.jar"]