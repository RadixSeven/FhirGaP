#!/bin/sh

docker build --build-arg UNIQUE_VALUE=`date --iso-8601=seconds` -t hapi-fhir/hapi-fhir-jpaserver-starter .

