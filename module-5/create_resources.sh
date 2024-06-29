# Create a resource group
az group create --name $RESOURCES_GROUP --location $REGION

# Create an Azure Container Registry (ACR)
az acr create \
    --resource-group $RESOURCES_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true
