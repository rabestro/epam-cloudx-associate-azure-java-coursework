MODULE=module4
export RESOURCES_GROUP=rg-$MODULE

# Delete a resource group
az group delete --name $RESOURCES_GROUP --yes --no-wait
