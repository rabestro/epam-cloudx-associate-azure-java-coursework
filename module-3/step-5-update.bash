# Push updated image to ACR from local computer

ACR_NAME=module3acr
VERSION=v2

die() {
    echo "$*" >&2
    exit 1
}

# Check if petstore directory exists
if [ ! -d "./petstore" ]; then
    die "Directory ./petstore does not exist"
fi

build_and_push_images() {
    echo "Logging in to ACR: $ACR_NAME"
    az acr login --name $ACR_NAME || die "Failed to log in to ACR: $ACR_NAME"
    cd ./petstore || die "Failed to navigate to ./petstore directory"

    for service in "$@"
    do
        az acr build \
            --image $service:$VERSION \
            --registry $ACR_NAME \
            --file $service/Dockerfile ./$service
        echo "Successfully built and pushed $service..."
    done
}

build_and_push_images "petstoreapp"
