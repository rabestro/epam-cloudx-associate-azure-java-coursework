# Module 3: App Services

# Step 3: Deploy Services to Azure App Services

ACR_NAME=module3acr
RESOURCES_GROUP=module3_rg
REGION1=eastus
REGION2=westeurope

die() {
    echo "$*" >&2
    exit 1
}

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
create_app_service_plan asp-web $REGION2
create_app_service_plan asp-api $REGION1

# Deploy PetStoreApp (Web) to two different regions

create_web_app petstoreapp asp-web-$REGION1 $REGION1
create_web_app petstoreapp asp-web-$REGION2 $REGION2

for service in "petstorepetservice" "petstoreorderservice" "petstoreproductservice"
do
    create_web_app $service asp-api-$REGION1 $REGION1
done
