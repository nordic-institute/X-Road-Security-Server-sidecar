#!/bin/bash

CLUSTER_NAME=$1
REGION_CODE=$2
USER_NAME=$3
USER_ARN=$4

ROLE="    - rolearn: $USER_ARN\n      username: $USER_NAME\n      groups:\n        - system:masters\n        - system:nodes"

kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml

kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"