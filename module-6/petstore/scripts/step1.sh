# Step 1: Set Up Azure Resources

export RESOURCES_GROUP=petstore6_rg
export REGION=westeurope
export ACR_NAME=petstore6acr

# Create a resource group
az group create --name $RESOURCES_GROUP --location $REGION

# Create an Azure Container Registry (ACR)
az acr create \
    --resource-group $RESOURCES_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true

# Step 2: Build and Push Docker Images

SERVICES=(
    "petstoreapp"
    "petstorepetservice"
    "petstoreorderservice"
    "petstoreproductservice"
    "orderitemsreserver"
)

die() {
    echo "$*" >&2
    exit 1
}

build_and_push_images() {
    echo "Logging in to ACR: $ACR_NAME"
    az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"

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
