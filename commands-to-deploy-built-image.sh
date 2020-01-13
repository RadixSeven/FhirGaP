gcloud auth login 
gcloud config set project fhir-gap-hapi-demo-jan-2020

sudo docker tag hapi-fhir/hapi-fhir-jpaserver-starter gcr.io/fhir-gap-hapi-demo-jan-2020/main-image

sudo gcloud docker -- push gcr.io/fhir-gap-hapi-demo-jan-2020/main-image

gcloud beta compute --project=fhir-gap-hapi-demo-jan-2020 instances create-with-container fhir-gap-demo --zone=us-east4-c --machine-type=n1-standard-1 --subnet=default --address=35.245.174.218 --network-tier=PREMIUM --metadata=google-logging-enabled=true --maintenance-policy=MIGRATE --service-account=616446538557-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,eighty-eighty-server --image=cos-stable-79-12607-80-0 --image-project=cos-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=fhir-gap-demo --container-image=gcr.io/fhir-gap-hapi-demo-jan-2020/main-image --container-restart-policy=always --container-stdin --container-tty --labels=container-vm=cos-stable-79-12607-80-0

gcloud compute instances update-container fhir-gap-demo --container-image  gcr.io/fhir-gap-hapi-demo-jan-2020/main-image
