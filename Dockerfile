FROM hapiproject/hapi:base as build-hapi

ARG HAPI_FHIR_URL=https://github.com/jamesagnew/hapi-fhir/
ARG HAPI_FHIR_BRANCH=master

RUN git clone --branch ${HAPI_FHIR_BRANCH} ${HAPI_FHIR_URL}
WORKDIR /tmp/hapi-fhir/
RUN /tmp/apache-maven-3.6.2/bin/mvn dependency:resolve
RUN /tmp/apache-maven-3.6.2/bin/mvn install -DskipTests


ARG REPO_URL_BASE=https://github.com/RadixSeven/
ARG REPO_URL_SUB=FhirGaP
ARG REPO_BRANCH=master
ARG UNIQUE_VALUE

WORKDIR /tmp
RUN git clone --branch ${REPO_BRANCH} ${REPO_URL_BASE}${REPO_URL_SUB} ${UNIQUE_VALUE}
RUN mv /tmp/${UNIQUE_VALUE} /tmp/FhirGaP

WORKDIR /tmp/FhirGaP
RUN /tmp/apache-maven-3.6.2/bin/mvn clean install -DskipTests

RUN mv /tmp/FhirGaP /tmp/${UNIQUE_VALUE}

FROM tomcat:9-jre11
ARG UNIQUE_VALUE

RUN mkdir -p /data/hapi/lucenefiles && chmod 775 /data/hapi/lucenefiles
COPY --from=build-hapi /tmp/${UNIQUE_VALUE}/target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]