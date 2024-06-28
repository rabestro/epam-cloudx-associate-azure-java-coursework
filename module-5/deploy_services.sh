source ./die.sh

create_web_app() {
    local service="$1-${REGION}"
    local plan="$2-${REGION}"
    
    echo "Creating Web App for service: $service in region: $REGION"
    
    az webapp create \
        --resource-group $RESOURCES_GROUP \
        --plan $plan \
        --name $service \
        --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
        || die "Failed to create Web App for service: $service in region: $REGION"
}

create_web_app petstoreapp asp-web

for service in petstorepetservice petstoreorderservice petstoreproductservice; do
    create_web_app $service asp-api
done

