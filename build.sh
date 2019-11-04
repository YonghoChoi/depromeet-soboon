#!/bin/sh

GO111MODULE=on
GOARCH=amd64
GOOS=linux
ROOT_PATH=$(pwd)
rm -rf ./bin/*

cd cmd/alertapi
go mod tidy
go build -o $ROOT_PATH/bin/alert-api

cd $ROOT_PATH