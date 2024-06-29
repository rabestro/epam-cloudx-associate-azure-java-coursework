source ./die.sh

echo "Logging in to ACR: $ACR_NAME"
az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"

cd ../petstore || die "Failed to navigate to ./petstore directory"
echo "Build and push images to $ACR_NAME"
for service in petstoreapp petstorepetservice petstoreorderservice petstoreproductservice
do
    az acr build \
        --image $service:v1 \
        --registry $ACR_NAME \
        --file $service/Dockerfile ./$service
    echo "Successfully built and pushed $service..."
done

cd ../module-5
