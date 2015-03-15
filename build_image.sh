#!/bin/sh
mvn clean install -DskipTests

rm -fr build
mkdir build
cp target/*.jar build/config-server.jar
docker build -t config-server .
