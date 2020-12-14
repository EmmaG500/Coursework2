#! /bin/bash

for i in {1..10}
do 
        curl $(minikube ip):$NODE_PORT
done 
