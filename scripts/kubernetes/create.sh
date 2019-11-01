#!/bin/bash
BASE_DIR=`pwd`
APP_ENV=$1

# must create configmap first
#dirs=(./common/configmap ./$APP_ENV/configmap ./common/pv ./$APP_ENV/pv ./common/deployment ./common/service ./common/job ./$APP_ENV/service)
dirs=(./common/configmap ./common/deployment)
for dir in "${dirs[@]}"
do
    cd $dir
    for filename in ./*.yaml; do
        kubectl create -f $filename
    done

    cd $BASE_DIR
done
