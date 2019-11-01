#!/bin/bash
until kubectl get nodes &> /dev/null
do
    echo "Waiting for provisioning kubernetes ..."
    sleep 5
done
echo "provisioning complete!"