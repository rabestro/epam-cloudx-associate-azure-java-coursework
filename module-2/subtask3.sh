#
# Subtask 3: Azure Container Registry (ACR)
#

# Set a variable for the Azure Container Registry name (use alphanumeric characters only).

ACR_NAME=subtask3acr

# Use the az acr create command to create an Azure Container Registry in the permanent resource group
# with the Basic service tier (SKU - Stock-Keeping Unit) and enabling the admin user authentication feature.

az acr create \
    --resource-group $PERMANENT_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true


# Use the az resource list command to list the resources in the permanent resource group.
# Use the proper option to get a table.

az resource list --resource-group $PERMANENT_GROUP --output table

# Use the az acr credential show command to retrieve the username and password.
# Use --output yaml option. This will display the credentials in a YAML format.
# Please make sure to save them for the next subtask.

az acr credential show --name $ACR_NAME --output yaml

ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query 'passwords[0].value' --output tsv)
