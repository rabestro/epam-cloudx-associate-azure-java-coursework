# Set Up Deployment Slots for PetStoreApp

RESOURCES_GROUP=module3_rg

# Upgrade App Service Plan

az appservice plan update \
    --name asp-web-eastus \
    --resource-group $RESOURCES_GROUP \
    --sku S1

# Create a deployment slot for one of PetStoreApps

az webapp deployment slot create \
    --name petstoreapp-eastus \
    --resource-group $RESOURCES_GROUP \
    --slot staging \
    --configuration-source petstoreapp-eastus
