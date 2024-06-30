export RESOURCES_GROUP=module3_rg
export REGION=eastus
export ACR_NAME=module3acr

die() {
    echo "$*" >&2
    exit 1
}

create_web_app() {
    local service_plan="asp-$1-$REGION"
    local service="$2-${REGION}"

    echo "Creating Web App for service: $service in region: $REGION"

    az webapp create \
        --resource-group $RESOURCES_GROUP \
        --plan $service_plan \
        --name $service \
        --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
        || die "Failed to create Web App for service: $service in region: $REGION"
}

create_web_app web petstoreapp
create_web_app api petstorepetservice
create_web_app api petstoreorderservice
create_web_app api petstoreproductservice
