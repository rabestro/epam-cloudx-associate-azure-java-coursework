# Step 1: Set Up Azure Resources

export RESOURCES_GROUP=module3_rg

export REGION1=eastus
export REGION=westeurope
# export REGION2=westeurope
export ACR_NAME=module3acr

# Create a resource group
az group create --name $RESOURCES_GROUP --location $REGION1

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
    local region=$2
    local service_plan="$1-${region}"

    echo "Creating App Service plan: $service_plan in region: $region"

    # Create App Service plan
    az appservice plan create \
        --name $service_plan \
        --resource-group $RESOURCES_GROUP \
        --location $region \
        --sku S1 \
        --is-linux \
        || die "Failed to create App Service plan: $service_plan in region: $region"
}

create_web_app() {
    local service=$1
    local plan=$2
    local region=$3

    echo "Creating Web App for service: $service in region: $region"

    az webapp create \
        --resource-group $RESOURCES_GROUP \
        --plan $plan \
        --name $service-$region \
        --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
        || die "Failed to create Web App for service: $service in region: $region"
}

# Create App Service Plans

create_app_service_plan asp-web $REGION1
create_app_service_plan asp-api $REGION1

# Deploy PetStoreApp (Web) to two different regions

create_web_app petstoreapp asp-web-$REGION1 $REGION1

for service in "petstorepetservice" "petstoreorderservice" "petstoreproductservice"
do
    create_web_app $service asp-api-$REGION1 $REGION1
done

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


# Create an Application Insights resource

az monitor app-insights component create \
    --app PetStoreInsight \
    --location $REGION1 \
    --resource-group $RESOURCES_GROUP \
    --application-type web

# Get the instrumentation key of an Application Insights resource
APP_INSIGHTS_KEY=$(az monitor app-insights component show --app PetStoreInsight --resource-group $RESOURCES_GROUP --query instrumentationKey --output tsv)

# Set the Application Insights connection string for an App Service
az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreapp-$REGION1 \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$APP_INSIGHTS_KEY"

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstorepetservice-$REGION1 \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$APP_INSIGHTS_KEY"

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreproductservice-$REGION1 \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$APP_INSIGHTS_KEY"

az webapp config appsettings set \
    --resource-group $RESOURCES_GROUP \
    --name petstoreorderservice-$REGION1 \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$APP_INSIGHTS_KEY"


# Set the Application Insights connection string for an App Service
enable_app_insights() {
    local service=$1

    az webapp config appsettings set \
        --resource-group $RESOURCES_GROUP \
        --name $service \
        --settings APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$APP_INSIGHTS_KEY" \
                   APPINSIGHTS_INSTRUMENTATIONKEY="$APP_INSIGHTS_KEY" \
                   ApplicationInsightsAgent_EXTENSION_VERSION="~2"
}

enable_app_insights petstoreapp-$REGION1
enable_app_insights petstorepetservice-$REGION1
enable_app_insights petstoreproductservice-$REGION1
enable_app_insights petstoreorderservice-$REGION1
