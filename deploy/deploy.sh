#!/usr/bin/env bash
cd $(dirname $0)
ROOT=$(pwd)
echo "the root is $ROOT"
mvn -DskipTests clean package spring-boot:build-image
