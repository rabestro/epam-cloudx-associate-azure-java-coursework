# Step 1: Set Up Azure Resources

export RESOURCES_GROUP=petstore_rg
export REGION=westeurope
export ACR_NAME=petstore5acr

# Create a resource group
az group create --name $RESOURCES_GROUP --location $REGION

# Create an Azure Container Registry (ACR)
az acr create \
    --resource-group $RESOURCES_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true

# Step 2: Build and Push Docker Images

SERVICES=("petstoreapp" "petstorepetservice" "petstoreorderservice" "petstoreproductservice")

die() {
    echo "$*" >&2
    exit 1
}

# Check if petstore directory exists
if [ ! -d "./petstore" ]; then
    die "Directory ./petstore does not exist"
fi

build_and_push_images() {
    echo "Logging in to ACR: $ACR_NAME"
    az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"
    cd ./petstore || die "Failed to navigate to ./petstore directory"

    for service in "${SERVICES[@]}"
    do
        az acr build \
            --image $service:v1 \
            --registry $ACR_NAME \
            --file $service/Dockerfile ./$service
        echo "Successfully built and pushed $service..."
    done
}

build_and_push_images

# Step 3: Deploy Services to Azure App Services

create_app_service_plan() {
    local service_plan="asp-$1-${REGION}"

    echo "Creating App Service plan: $service_plan in region: $REGION"

    # Create App Service plan
    az appservice plan create \
        --name $service_plan \
        --resource-group $RESOURCES_GROUP \
        --location $REGION \
        --sku S1 \
        --is-linux \
        || die "Failed to create App Service plan: $service_plan in region: $REGION"
}

# Create App Service Plans
create_app_service_plan web
create_app_service_plan api

create_web_app() {
    local plan="asp-$1-${REGION}"
    local service=$2

    echo "Creating Web App for service: $service in region: $REGION"

    az webapp create \
        --resource-group $RESOURCES_GROUP \
        --plan $plan \
        --name $service-$REGION \
        --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
        || die "Failed to create Web App for service: $service in region: $REGION"
}

# Deploy PetStoreApp (Web)
create_web_app web petstoreapp web
create_web_app api petstorepetservice
create_web_app api petstoreorderservice
create_web_app api petstoreproductservice

# Configure Services
az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreapp-$REGION \
    --settings \
    WEBSITES_PORT=8080 \
    PETSTOREAPP_SERVER_PORT=8080 \
    PETSTOREPETSERVICE_URL=https://petstorepetservice-$REGION.azurewebsites.net \
    PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice-$REGION.azurewebsites.net \
    PETSTOREORDERSERVICE_URL=https://petstoreorderservice-$REGION.azurewebsites.net

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


# Create an Application Insights resource
az monitor app-insights component create \
    --app PetStoreInsight \
    --location $REGION \
    --resource-group $RESOURCES_GROUP \
    --application-type web

# Get the instrumentation key of an Application Insights resource
APP_INSIGHTS_KEY=$(az monitor app-insights component show \
    --app PetStoreInsight \
    --resource-group $RESOURCES_GROUP \
    --query instrumentationKey --output tsv)
