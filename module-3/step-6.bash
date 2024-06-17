# Step 6: Configure Traffic Manager

RESOURCES_GROUP=module3_rg

# Create Traffic Manager profile

az network traffic-manager profile create \
    --resource-group $RESOURCES_GROUP \
    --name petstoreapp-tm \
    --routing-method Priority \
    --unique-dns-name petstoreapp-tm

# Get the IDs of the App Services
APP1_ID=$(az webapp show --name petstoreapp-eastus --resource-group $RESOURCES_GROUP --query id --output tsv)
APP2_ID=$(az webapp show --name petstoreapp-westeurope --resource-group $RESOURCES_GROUP --query id --output tsv)

# Add endpoints
az network traffic-manager endpoint create \
    --resource-group $RESOURCES_GROUP \
    --profile-name petstoreapp-tm \
    --name tm-petstoreapp-eastus \
    --type azureEndpoints \
    --target-resource-id $APP1_ID \
    --priority 1

az network traffic-manager endpoint create \
    --resource-group $RESOURCES_GROUP \
    --profile-name petstoreapp-tm \
    --name tm-petstoreapp-westeurope \
    --type azureEndpoints \
    --target-resource-id $APP2_ID \
    --priority 2

# List all resources in a resource group
az resource list --resource-group $RESOURCES_GROUP --output table
