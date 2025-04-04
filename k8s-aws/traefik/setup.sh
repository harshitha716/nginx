# kustomize build . | kubectl apply -f -


#!/bin/bash -x
set -e

function throw_error() {
    echo -e "Error: $1"
    exit 1
}

if [[ ! "( dev stg prd  )" =~ " ${1} " ]]; then
    throw_error "Please provide a valid environment name as 1st Parameter\nValid Values: dev, stg, prd \n\n"
else
    ENV_NAME=$1
fi

#Installing the jinja dependencies
pip3 install -r ../requirements.txt

#Rendering the jinja template
source ../config/$ENV_NAME.env
DIR=`pwd`
../render.sh $DIR

# gcloud container clusters get-credentials zamp-$ENV-sg-gke-cluster --project=$PROJECT_ID --region=asia-southeast2

kustomize build . --enable-helm | kubectl apply -f -

#cleanup

rm -rf $(cat rendered_files)

rm -rf rendered_files

rm -rf charts/*.tgz