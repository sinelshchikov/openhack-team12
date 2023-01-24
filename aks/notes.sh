# Initial ENV vars

export RESOURCE_GROUP=teamResources
export CLUSTER_NAME=aks-team12-cluser
export LOCATION="South Central US"

# Deploy the AKS cluster

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --node-count 2 \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --network-plugin azure \
    --vnet-subnet-id ####### \
    --enable-aad
    --attach-acr registryhrh2972

# Generating kube config to access the cluster

az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP

# Setting up AKS secret for MSSQL

kubectl create secret generic sql \
--from-literal=sqluser="sqladminhRh2972" \
--from-literal=sqlpassword="Password@2345"

# Verifications of deployments and services

kubectl port-forward deployment/poi 28015:80
kubectl port-forward deployment/user-java 28015:80
kubectl port-forward deployment/userprofile 28015:80
kubectl port-forward deployment/tripviewer 28015:80

kubectl port-forward service/trips-service 28015:80
kubectl port-forward service/userprofile-service 28015:80
kubectl port-forward service/user-java-service 28015:80
kubectl port-forward service/poi-service 28015:80