export RESOURCES_GROUP=petstore6_rg
export REGION=westeurope
export ACR_NAME=petstore6acr

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

    echo "Creating Web App for service: $service in region: $REGION"

    az webapp create \
        --resource-group $RESOURCES_GROUP \
        --plan $plan \
        --name "$service-$REGION" \
        --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
        || die "Failed to create Web App for service: $service in region: $REGION"
}

# Create App Service Plans

create_app_service_plan asp-web $REGION
create_app_service_plan asp-api $REGION

# Deploy PetStoreApp (Web)

create_web_app petstoreapp asp-web-$REGION

for service in petstorepetservice petstoreorderservice petstoreproductservice orderitemsreserver
do
    create_web_app $service asp-api-$REGION
done
