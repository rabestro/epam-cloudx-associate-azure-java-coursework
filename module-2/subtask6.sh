#
# Subtask 6: Creating a Web App in Azure App Services
#

# Use the az group create command to create a temporary resource group in East US location.

az group create --name $TEMPORARY_GROUP --location $PERMANENT_LOCATION

# Use the az appservice plan create command to create an App Service plan in East US location.

az appservice plan create \
    --name webapp-plan \
    --resource-group $TEMPORARY_GROUP \
    --location $PERMANENT_LOCATION \
    --is-linux \
    --sku B1

# Use the az webapp create command to create the web app and deploy the container image.

az webapp create \
    --resource-group $TEMPORARY_GROUP \
    --plan webapp-plan \
    --name epam-cloudx-jegors-webapp \
    --deployment-container-image-name $ACR_NAME.azurecr.io/webapp:latest \
    --container-registry-password $ACR_PASSWORD \
    --container-registry-user $ACR_USERNAME

# https://epam-cloudx-jegors-webapp.azurewebsites.net

# Once you have confirmed that the web app is running correctly, to save costs,
# delete the temporary resource group

az group delete --name $TEMPORARY_GROUP --yes --no-wait
