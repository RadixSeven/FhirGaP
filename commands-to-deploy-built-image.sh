sudo docker tag hapi-fhir/hapi-fhir-jpaserver-starter gcr.io/fhir-gap-hapi-demo-jan-2020/main-image
gcloud auth login 
gcloud config set project fhir-gap-hapi-demo-jan-2020
sudo gcloud docker -- push gcr.io/fhir-gap-hapi-demo-jan-2020/main-image
