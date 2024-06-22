# Module 4: Container Apps (Steps 1 & 2)

MODULE=module4
export RESOURCES_GROUP=rg_$MODULE
export ACR_NAME=${MODULE}acr
export REGION=westeurope
export SERVICES=(petstoreapp petstorepetservice petstoreorderservice petstoreproductservice)

die() {
    echo "$*" >&2
    exit 1
}

create_resources() {
    # Create a resource group
    az group create --name $RESOURCES_GROUP --location $REGION

    # Create an Azure Container Registry (ACR)
    az acr create \
        --resource-group $RESOURCES_GROUP \
        --name $ACR_NAME \
        --sku Basic \
        --admin-enabled true
}

check_petstore_directory() {
    # Check if petstore directory exists
    if [ ! -d "./petstore" ]; then
        die "Directory ./petstore does not exist"
    fi
}

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

# Step 1: Set Up Azure Resources
create_resources

# Step 2: Build and Push Docker Images
check_petstore_directory
build_and_push_images

# List all resources in a resource group
az resource list --resource-group $RESOURCES_GROUP --output table

# List all repositories in an ACR
az acr repository list --name $ACR_NAME --output table
