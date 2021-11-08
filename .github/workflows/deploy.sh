#!/usr/bin/env bash
set -e
cd "${GITHUB_WORKSPACE:-$(dirname $0)/../..}"

function module_name(){
  echo "gcr.io/pgtm-jlong/$1"
}

function deploy_module(){
  NAME=$1
  IMAGE_NAME=$(module_name "$NAME")
  docker rmi -f $IMAGE_NAME
  ./mvnw -DskipTests=true clean package spring-boot:build-image \
        -Dspring-boot.build-image.imageName=$IMAGE_NAME
  docker push $IMAGE_NAME
}

deploy_module customers
