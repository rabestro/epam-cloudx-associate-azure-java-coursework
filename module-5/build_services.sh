source ./die.sh

# colima start

echo "Logging in to ACR: $ACR_NAME"
az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"

echo "Build and push images to $ACR_NAME"
for service in petstoreapp petstorepetservice petstoreorderservice petstoreproductservice
do
    az acr build \
        --image $service:v1 \
        --registry $ACR_NAME \
        --file ../petstore/$service/Dockerfile ../petstore/$service
    echo "Successfully built and pushed $service..."
done
