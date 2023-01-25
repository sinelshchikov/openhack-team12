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
    --vnet-subnet-id /subscriptions/f23ec1a2-c46f-49fd-a66a-40d273192a7a/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/vm-subnet \
    --attach-acr registryhrh2972 \
    --enable-aad \
    --aad-admin-group-object-ids a900925f-6eaa-4c27-a6d1-5d5de01c831b \
    --aad-tenant-id 05943c2a-656a-4257-a6a2-4499cfecf805 

# Generating kube config to access the cluster

az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --admin

# Setting up AKS secret for MSSQL

kubectl create secret generic sql \
--from-literal=sqluser="sqladminhRh2972" \
--from-literal=sqlpassword="Password@2345" \
-n api

# Verifications of deployments and services

kubectl port-forward deployment/poi 28015:80
kubectl port-forward deployment/user-java 28015:80
kubectl port-forward deployment/userprofile 28015:80
kubectl port-forward deployment/tripviewer 28015:80

kubectl port-forward service/trips-service 28015:80
kubectl port-forward service/userprofile-service 28015:80
kubectl port-forward service/user-java-service 28015:80
kubectl port-forward service/poi-service 28015:80

# Challange #3

# Create Namespace
kubectl create namespace api
kubectl create namespace web

# RBAC setup for AKS

kubectl exec -it tripviewer-798c8644f9-x4vcm -- /bin/sh


AKS_ID=$(az aks show \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --query id -o tsv)

az role assignment create \
  --assignee $APPDEV_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

web-deb / WebSecureUser@345#$%

az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --overwrite-existing