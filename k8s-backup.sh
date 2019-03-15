#!/bin/bash

# Get all kubernetes resources

datenow=$(date +'%d-%m-%Y')
pathToSave="/home/usefree/K8s-Backup-$datenow"

for namespace in dev default
do
    for resource in pods statefulset service deployment secrets prometheusrules clusterroles rolebinding
    do
        if [ ! -d $pathToSave/$namespace/$resource ]; then
            echo "Creating $pathToSave/$namespace/$resource"
            mkdir -p $pathToSave/$namespace/$resource
        fi
        
        for file in $(kubectl get $resource -n $namespace | awk '{print$1}' | cut -d / -f2 | grep -v NAME);
        do
            echo "Writing file $file.yaml to $pathToSave/$namespace/$resource/";
            kubectl get $resource $file -n $namespace -o yaml > $pathToSave/$namespace/$resource/$file.yaml;
        done;
    done;
done;

cd ../$pathToSave
tar -cvf k8sBackup-$datenow.tar $pathToSave
echo "All jobs finished."
