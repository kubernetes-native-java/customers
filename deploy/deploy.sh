#!/usr/bin/env bash
cd $GITHUB_WORKSPACE

PREFIX=knj
IMAGE=customers
IMAGE_NAME=$PREFIX/$IMAGE

./mvnw -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=$IMAGE_NAME
docker run  -p 8081:8081 -e SERVER_PORT=8081 $IMAGE_NAME
