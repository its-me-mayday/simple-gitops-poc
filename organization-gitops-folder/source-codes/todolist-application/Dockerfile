FROM gcr.io/distroless/java21:nonroot
WORKDIR /app
COPY target/*.jar /app/app.jar
USER nonroot
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]