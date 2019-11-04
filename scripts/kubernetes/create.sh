#!/bin/bash
BASE_DIR=`pwd`
APP_ENV=$1

# must create configmap first
#dirs=(./configmap ./$APP_ENV/configmap ./pv ./$APP_ENV/pv ./deployment ./service ./job ./$APP_ENV/service)
dirs=(./configmap ./pv ./deployment ./service)
for dir in "${dirs[@]}"
do
    cd $dir
    for filename in ./*.yaml; do
        kubectl create -f $filename
    done

    cd $BASE_DIR
done
