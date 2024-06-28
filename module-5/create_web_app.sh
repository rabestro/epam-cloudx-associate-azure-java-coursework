service="$1-${REGION}"
plan="$2-${REGION}"

echo "Creating Web App for service: $service in region: $REGION"

az webapp create \
    --resource-group $RESOURCES_GROUP \
    --plan $plan \
    --name $service \
    --deployment-container-image-name $ACR_NAME.azurecr.io/$service:v1 \
    || die "Failed to create Web App for service: $service in region: $REGION"
