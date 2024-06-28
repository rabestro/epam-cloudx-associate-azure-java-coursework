# Module 4: Container Apps
# Step 5: Deploy Multiple Revisions Simultaneously for PetStoreApp

MODULE=module4
export RESOURCES_GROUP=rg-$MODULE
export ACR_NAME=${MODULE}acr
export REGION=westeurope
export APP_ENV=$ACR_NAME-env

print_images_with_tags() {
    # List all images and their tags in an ACR
    for image in $(az acr repository list --name $ACR_NAME --output tsv); do
        echo "Image: $image"
        echo "Tags:"
        az acr repository show-tags \
            --name $ACR_NAME \
            --repository $image \
            --output table
    done
}

az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"
cd ./petstore || die "Failed to navigate to ./petstore directory"

service=petstoreapp
version=v2

az acr build \
    --image $service:$version \
    --registry $ACR_NAME \
    --file $service/Dockerfile ./$service \
    || die "Failed to build service: $service"

echo "Successfully built and pushed $service..."
cd ..

# List all repositories in an ACR
az acr repository list --name $ACR_NAME --output table

print_images_with_tags
