#!/bin/bash

# Read current value of productionSlot to deploy release in other slot
currentSlot=`(helm get values --all broker-hdngo | ggrep -Po 'productionSlot: \K.*')`
if [ "$currentSlot" == "blue" ]; then
    newSlot="green"
    oldSlot="blue"
else
    newSlot="blue"
    oldSlot="green"
fi

echo "currentSlot: $currentSlot"
echo "newSlot: $newSlot"

# Deploying to new slot
deploymentOption=$newSlot.enabled=true
helm upgrade --install broker-hdngo ./broker --set $deploymentOption --reuse-values

READY=$(kubectl get deploy proton-la-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$READY" != "True" ]]; do
    READY=$(kubectl get deploy proton-la-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Deployment Ready: $READY"

# Promoting deployment to serve production traffic
deploymentOption=productionSlot=$newSlot
helm upgrade --install broker-hdngo ./broker --set $deploymentOption --reuse-values

# Deleting deployment in old slot
deploymentOption=$oldSlot.enabled=false
helm upgrade --install broker-hdngo ./broker --set $deploymentOption --reuse-values
