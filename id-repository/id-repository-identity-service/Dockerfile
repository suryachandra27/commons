FROM openjdk:8

#Uncomment below and Comment above line(i.e. FROM openjdk:8) for OS specific (e.g. Alpine OS ) docker base image
#FROM openjdk:8-jdk-alpine

# can be passed during Docker build as build time environment for github branch to pickup configuration from.
ARG spring_config_label

# can be passed during Docker build as build time environment for spring profiles active 
ARG active_profile

# can be passed during Docker build as build time environment for config server URL 
ARG spring_config_url

# can be passed during Docker build as build time environment for glowroot 
ARG is_glowroot

# can be passed during Docker build as build time environment for artifactory URL
ARG artifactory_url

# environment variable to pass active profile such as DEV, QA etc at docker runtime
ENV active_profile_env=${active_profile}

# environment variable to pass github branch to pickup configuration from, at docker runtime
ENV spring_config_label_env=${spring_config_label}

# environment variable to pass spring configuration url, at docker runtime
ENV spring_config_url_env=${spring_config_url}

# environment variable to pass glowroot, at docker runtime
ENV is_glowroot_env=${is_glowroot}

# environment variable to pass artifactory url, at docker runtime
ENV artifactory_url_env=${artifactory_url}

#Consul-template Settings
COPY ./config.hcl /etc/consul-template.d/config.hcl

COPY ./target/id-repository-identity-service-*.jar id-repository-identity-service.jar

#ADD http://13.71.87.138:8040/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/0.9.1/kernel-ref-idobjectvalidator-0.9.1.jar kernel-ref-idobjectvalidator-0.9.1.jar

EXPOSE 8090


CMD if [ "$is_glowroot_env" = "present" ]; then \
    wget "${artifactory_url_env}"/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/0.9.1/kernel-ref-idobjectvalidator-0.9.1.jar kernel-ref-idobjectvalidator-0.9.1.jar ; \
    wget "${artifactory_url_env}"/artifactory/libs-release-local/io/mosip/testing/glowroot.zip ; \
    wget "${artifactory_url_env}"/artifactory/libs-release-local/io/mosip/testing/cert/consul-template.zip ; \
    apt-get update && apt-get install -y unzip openssl ; \
    unzip glowroot.zip ; \
    unzip consul-template.zip ; \
    ./consul-template -config=/etc/consul-template.d/config.hcl ; \
    rm -rf ./cert/* ; \
    rm -rf glowroot.zip; \

    sed -i 's/<service_name>/id-repository-identity-service/g' glowroot/glowroot.properties ; \
    java -Dloader.path=/kernel-ref-idobjectvalidator-0.9.1.jar -jar -javaagent:glowroot/glowroot.jar -Dserver.ssl.key-alias="${ssl_key_alias}" -Dspring.cloud.config.label="${spring_config_label_env}" -Dspring.profiles.active="${active_profile_env}"  -Dspring.cloud.config.uri="${spring_config_url_env}" id-repository-identity-service.jar ; \
    else \
    wget "${artifactory_url_env}"/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/0.9.1/kernel-ref-idobjectvalidator-0.9.1.jar kernel-ref-idobjectvalidator-0.9.1.jar ; \
    wget "${artifactory_url_env}"/artifactory/libs-release-local/io/mosip/testing/cert/consul-template.zip ; \
    apt-get update && apt-get install -y unzip openssl ; \
    unzip consul-template.zip ; \
    ./consul-template -config=/etc/consul-template.d/config.hcl ; \
    rm -rf ./cert/* ; \

-Dserver.ssl.key-alias="${ssl_key_alias}"

    java -Dloader.path=/kernel-ref-idobjectvalidator-0.9.1.jar -jar -Dserver.ssl.key-alias="${ssl_key_alias}" -Dspring.cloud.config.label="${spring_config_label_env}" -Dspring.profiles.active="${active_profile_env}"  -Dspring.cloud.config.uri="${spring_config_url_env}" id-repository-identity-service.jar ; \
    fi

#CMD ["java","-Dloader.path=/kernel-ref-idobjectvalidator-0.9.1.jar","-jar","-Dspring.cloud.config.label=${spring_config_label_env}","-Dspring.profiles.active=${active_profile_env}","-Dspring.cloud.config.uri=${spring_config_url_env}","id-repository-identity-service.jar"]
