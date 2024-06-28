# Module 4: Container Apps
# Step 5: Deploy Multiple Revisions Simultaneously for PetStoreApp
# Task: Deploy the newly built image as a new revision

MODULE=module4
export RESOURCES_GROUP=rg-$MODULE
export ACR_NAME=${MODULE}acr
export REGION=westeurope
export APP_ENV=$ACR_NAME-env

# Deploy a new revision of a Container App
deploy_new_revision() {
    local service=$1
    local revision_suffix=$2

    az containerapp update \
        --resource-group $RESOURCES_GROUP \
        --name $service \
        --image $ACR_NAME.azurecr.io/$service:$revision_suffix \
        --revision-suffix $revision_suffix
}

# Deploy new revisions of the services
deploy_new_revision petstoreapp v2
