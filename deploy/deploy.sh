#!/usr/bin/env bash
cd $GITHUB_WORKSPACE
echo "the root is $ROOT"
mvn -DskipTests clean package spring-boot:build-image

