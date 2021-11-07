#!/usr/bin/env bash
set -e
cd "${GITHUB_WORKSPACE:-$(dirname $0)/../..}"
pwd
MANIFESTS_DIR=$(pwd)/k8s/manifests
PREFIX=bootiful
NS=knj
APP_NAME=customers
IMAGE_NAME=gcr.io/${PREFIX}/${APP_NAME}:latest

#./mvnw -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=${IMAGE_NAME}


# docker run -e SPRING_PROFILES_ACTIVE=cloud -e SERVER_PORT=8082 -p 8082:8082 $IMAGE_NAME
GOOGLE_APPLICATION_CREDENTIALS=${GITHUB_WORKSPACE}/gcp.json
echo $GCLOUD_SA_KEY > $GOOGLE_APPLICATION_CREDENTIALS
echo $(  cat $GOOGLE_APPLICATION_CREDENTIALS | wc -l )
docker login -u _json_key -p "$(cat ${GOOGLE_APPLICATION_CREDENTIALS})" https://gcr.io
docker push $IMAGE_NAME
echo "pushed the image to ${IMAGE_NAME}"
mkdir -p $MANIFESTS_DIR
kubectl create ns $NS  -o yaml > $MANIFESTS_DIR/namespace.yaml
kubectl -n $NS create deployment  --image=$IMAGE_NAME $APP_NAME -o yaml > $MANIFESTS_DIR/deployment.yaml
kubectl -n $NS expose deployment $APP_NAME --port=8080 -o yaml > $MANIFESTS_DIR/service.yaml
sleep 5
kubectl -n $NS port-forward deployment/$APP_NAME 8080:8080  &

curl -s localhost:8080/actuator/health/liveness | jq


