# Step 1: Set Up Azure Resources

export RESOURCES_GROUP=module3_rg
export REGION1=eastus
export REGION2=westeurope
export ACR_NAME=module3acr

# Create a resource group
az group create --name $RESOURCES_GROUP --location $REGION1

# Create an Azure Container Registry (ACR)
az acr create \
    --resource-group $RESOURCES_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true
