#!/bin/bash

kubectl proxy & >/dev/null
kubectl delete namespace $1 >/dev/null &
kubectl get namespace $1 -o json | jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$1/finalize >/dev/null