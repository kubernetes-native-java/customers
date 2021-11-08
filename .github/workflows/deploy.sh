#!/usr/bin/env bash
set -e

ROOT=${GITHUB_WORKSPACE:-$(cd $(dirname $0)/../.. && pwd)}
NAME=$1
IMAGE_NAME="gcr.io/${GCLOUD_PROJECT}/${NAME}"

#docker rmi -f $IMAGE_NAME || echo "no local image to delete..."
#cd $ROOT && ./mvnw -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=$IMAGE_NAME
#docker push $IMAGE_NAME

curl -H "Accept: application/vnd.github.everest-preview+json" -H "Authorization: token ${GH_PAT}" \
 --request POST  --data '{"event_type": "deploy-event"}' \
 https://api.github.com/repos/kubernetes-native-java/crm-deployment/dispatches && \
 echo "triggered a deploy-event"

