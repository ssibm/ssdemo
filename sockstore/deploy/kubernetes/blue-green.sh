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

# Check each deployment to see if they're ready
# Probably a more efficient way to do this

# Checking carts
CARTS_READY=$(kubectl get deploy carts-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$CARTS_READY" != "True" ]]; do
    CARTS_READY=$(kubectl get deploy carts -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Carts Ready: $CARTS_READY"

# Checking carts db
CARTS_DB_READY=$(kubectl get deploy carts-db-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$CARTS_DB_READY" != "True" ]]; do
    CARTS_DB_READY=$(kubectl get deploy carts-db -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Carts DB Ready: $CARTS_DB_READY"

# Checking catalogue
CATALOGUE_READY=$(kubectl get deploy catalogue-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$CATALOGUE_READY" != "True" ]]; do
    CATALOGUE_READY=$(kubectl get deploy catalogue -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Catalogue Ready: $CATALOGUE_READY"

# Checking catalogue db
CATALOGUE_DB_READY=$(kubectl get deploy catalogue-db-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$CATALOGUE_DB_READY" != "True" ]]; do
    CATALOGUE_DB_READY=$(kubectl get deploy catalogue-db -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Catalogue DB Ready: $CATALOGUE_DB_READY"

# Checking front-end
FRONT_END_READY=$(kubectl get deploy front-end-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$FRONT_END_READY" != "True" ]]; do
    FRONT_END_READY=$(kubectl get deploy front-end -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Front-End Ready: $FRONT_END_READY"

# Checking orders
ORDERS_READY=$(kubectl get deploy orders-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$ORDERS_READY" != "True" ]]; do
    ORDERS_READY=$(kubectl get deploy orders -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Orders Ready: $ORDERS_READY"

# Checking orders db
ORDERS_DB_READY=$(kubectl get deploy orders-db-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$ORDERS_DB_READY" != "True" ]]; do
    ORDERS_DB_READY=$(kubectl get deploy orders-db -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Orders DB Ready: $ORDERS_DB_READY"

# Checking payment
PAYMENT_READY=$(kubectl get deploy payment-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$PAYMENT_READY" != "True" ]]; do
    PAYMENT_READY=$(kubectl get deploy payment -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Payment Ready: $PAYMENT_READY"

# Checking queue master
QUEUE_MASTER_READY=$(kubectl get deploy queue-master-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$QUEUE_MASTER_READY" != "True" ]]; do
    QUEUE_MASTER_READY=$(kubectl get deploy queue-master -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Queue Master Ready: $QUEUE_MASTER_READY"

# Checking rabbitmq
RABBITMQ_READY=$(kubectl get deploy rabbitmq-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$RABBITMQ_READY" != "True" ]]; do
    RABBITMQ_READY=$(kubectl get deploy rabbitmq -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "RabbitMQ Ready: $RABBITMQ_READY"

# Checking session db
SESSION_DB_READY=$(kubectl get deploy session-db-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$SESSION_DB_READY" != "True" ]]; do
    SESSION_DB_READY=$(kubectl get deploy session-db -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Session DB Ready: $SESSION_DB_READY"

# Checking shipping
SHIPPING_READY=$(kubectl get deploy shipping-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$SHIPPING_READY" != "True" ]]; do
    SHIPPING_READY=$(kubectl get deploy shipping -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "Shipping DB Ready: $SHIPPING_READY"

# Checking user
USER_READY=$(kubectl get deploy user-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$USER_READY" != "True" ]]; do
    USER_READY=$(kubectl get deploy user -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "User Ready: $USER_READY"

# Checking user db
USER_DB_READY=$(kubectl get deploy user-db-$newSlot -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$USER_DB_READY" != "True" ]]; do
    USER_DB_READY=$(kubectl get deploy user-db -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "User DB Ready: $USER_DB_READY"

# Promoting deployment to serve production traffic
deploymentOption=productionSlot=$newSlot
helm upgrade --install broker-hdngo ./broker --set $deploymentOption --reuse-values

# Deleting deployment in old slot
deploymentOption=$oldSlot.enabled=false
helm upgrade --install broker-hdngo ./broker --set $deploymentOption --reuse-values
