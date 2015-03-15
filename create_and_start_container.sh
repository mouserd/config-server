#!/bin/sh
docker rm config-server

docker run \
  -p 8888:8888 \
  --name config-server \
  -e PORT=8888
  -d config-server
