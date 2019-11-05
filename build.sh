#!/bin/sh

export GO111MODULE=on
export GOARCH=amd64
export GOOS=linux
export ROOT_PATH=$(pwd)
rm -rf ./bin/*

cd cmd/alertapi
go mod tidy
go build -o $ROOT_PATH/bin/alert-api

cd $ROOT_PATH