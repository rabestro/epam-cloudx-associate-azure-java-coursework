az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreapp-$REGION \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREAPP_SERVER_PORT=8080 \
    PETSTOREPETSERVICE_URL=https://petstorepetservice-eastus.azurewebsites.net \
    PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice-eastus.azurewebsites.net \
    PETSTOREORDERSERVICE_URL=https://petstoreorderservice-eastus.azurewebsites.net
    
az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstorepetservice-$REGION \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREPETSERVICE_SERVER_PORT=8080

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreproductservice-$REGION \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREPRODUCTSERVICE_SERVER_PORT=8080

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreorderservice-$REGION \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREORDERSERVICE_SERVER_PORT=8080 \
    PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice-eastus.azurewebsites.net    