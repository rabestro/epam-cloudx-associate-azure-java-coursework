# Configure environment variables

RESOURCES_GROUP=module3_rg
REGION1=eastus
REGION2=westeurope

configure_web_app() {
    local region=$1
    az webapp config appsettings set \
        --resource-group $RESOURCES_GROUP \
        --name petstoreapp-$region \
        --settings \
        WEBSITES_PORT=8080 \
        PETSTOREAPP_SERVER_PORT=8080 \
        PETSTOREPETSERVICE_URL=https://petstorepetservice-eastus.azurewebsites.net \
        PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice-eastus.azurewebsites.net \
        PETSTOREORDERSERVICE_URL=https://petstoreorderservice-eastus.azurewebsites.net
}

configure_web_app $REGION1
configure_web_app $REGION2

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstorepetservice-eastus \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREPETSERVICE_SERVER_PORT=8080

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreproductservice-eastus \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREPRODUCTSERVICE_SERVER_PORT=8080

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreorderservice-eastus \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREORDERSERVICE_SERVER_PORT=8080 \
    PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice-eastus.azurewebsites.net
