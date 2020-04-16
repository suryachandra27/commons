FROM openjdk:8

#Uncomment below and Comment above line(i.e. FROM openjdk:8) for OS specific (e.g. Alpine OS ) docker base image
#FROM openjdk:8-jdk-alpine

COPY ./target/kernel-vidgenerator-service-*.jar kernel-vidgenerator-service.jar

EXPOSE 8099

CMD ["java","-jar", "-Dspring.cloud.config.label=master", "-Dspring.cloud.config.name=kernel", "-Dspring.profiles.active=qa", "-Dspring.cloud.config.uri=http://kernel-config-server:51000/config","kernel-vidgenerator-service.jar"]
