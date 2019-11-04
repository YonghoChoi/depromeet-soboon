#!/bin/bash
BASE_DIR=`pwd`
APP_ENV=$1

#dirs=(./$APP_ENV/service ./configmap ./$APP_ENV/configmap ./deployment ./service ./job ./pv ./$APP_ENV/pv)
dirs=(./configmap ./deployment ./pv ./service)
for dir in "${dirs[@]}"
do
    cd $dir
    for filename in ./*.yaml; do
        kubectl delete -f $filename
    done

    cd $BASE_DIR
done
