#!/bin/bash
BASE_DIR=`pwd`
APP_ENV=$1

#dirs=(./$APP_ENV/service ./common/configmap ./$APP_ENV/configmap ./common/deployment ./common/service ./common/job ./common/pv ./$APP_ENV/pv)
dirs=(./common/configmap ./common/deployment ./common/pv ./common/service)
for dir in "${dirs[@]}"
do
    cd $dir
    for filename in ./*.yaml; do
        kubectl delete -f $filename
    done

    cd $BASE_DIR
done
