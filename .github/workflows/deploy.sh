#!/usr/bin/env bash
set -e

ROOT=${GITHUB_WORKSPACE:-$(cd $(dirname $0)/../.. && pwd)}

function module_name() {
  echo "gcr.io/${GCLOUD_PROJECT}/$1"
}

function deploy_module() {
  NAME=$1
  IMAGE_NAME=$(module_name "$NAME")
  OUTPUT_FN=$ROOT/tmp/${NAME}-generated.yaml

  mkdir -p "$(dirname $OUTPUT_FN)" || echo "could not create ${OUTPUT_FN}."

  docker rmi -f $IMAGE_NAME
  ./mvnw -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=$IMAGE_NAME
  docker push $IMAGE_NAME

  cat $ROOT/.github/workflows/k8s.yaml.template |
    sed -e 's,<NS>,'${K8S_NS}',g' |
    sed -e 's,<APP>,'${NAME}',g' |
    sed -e 's,<GCR_PROJECT>,'${GCLOUD_PROJECT}',g' >$OUTPUT_FN
  cat $OUTPUT_FN
  kubectl apply -f $OUTPUT_FN -n $K8S_NS
}

echo "starting in $ROOT. "
cd $ROOT/../..
ls -la
deploy_module customers
