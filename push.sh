#!/bin/sh

docker login
docker build -t yonghochoi/soboon-alert-api .
docker push yonghochoi/soboon-alert-api