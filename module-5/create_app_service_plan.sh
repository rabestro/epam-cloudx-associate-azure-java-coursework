source ./die.sh

service_plan="$1-${REGION}"

echo "Creating App Service plan: $service_plan in region: $REGION"

# Create App Service plan
az appservice plan create \
    --name $service_plan \
    --resource-group $RESOURCES_GROUP \
    --location $REGION \
    --sku S1 \
    --is-linux \
    || die "Failed to create App Service plan: $service_plan in region: $REGION"
