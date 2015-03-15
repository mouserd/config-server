#!/bin/sh
docker stop config-server
docker rm config-server

docker run \
  -p 8888:8888 \
  --name config-server \
  -e PORT=8888 \
  -d config-server
