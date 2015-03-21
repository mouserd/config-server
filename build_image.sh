#!/bin/sh
mvn clean install -DskipTests -s ~/.m2/settings-no-nexus.xml

rm -fr build
mkdir build
cp target/config-server.jar build/config-server.jar
docker build -t config-server .
