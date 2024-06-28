source ./die.sh

export RESOURCES_GROUP=module5_rg
export ACR_NAME=module5acr
export REGION=eastus

az login
./create_resources.sh      || die "Failed to create resources"
[ -d "../petstore" ]       || die "Directory ../petstore does not exist"
./build_services.sh        || die "Failed to build images"

# Create App Service Plans
./create_app_service_plan.sh asp-web
./create_app_service_plan.sh asp-api

# Deploy Services
./deploy_services.sh
./configure_services.sh

# Create an Application Insights resource
az monitor app-insights component create \
    --app PetStoreInsight \
    --location $REGION \
    --resource-group $RESOURCES_GROUP \
    --application-type web
