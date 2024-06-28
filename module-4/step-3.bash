# Module 4: Container Apps
# Step 3: Deploy Services to Azure Container Apps

MODULE=module4
export RESOURCES_GROUP=rg-$MODULE
export ACR_NAME=${MODULE}acr
export REGION=westeurope
export APP_ENV=$ACR_NAME-env

# Get the ACR credentials
export ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query "username" --output tsv)
export ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" --output tsv)

die() {
    echo "$*" >&2
    exit 1
}

create_container_app_environment() {
    az containerapp env create \
        --resource-group $RESOURCES_GROUP \
        --name $APP_ENV \
        --location $REGION \
        --enable-workload-profiles false \
        || die "Failed to create Container App Env: $APP_ENV in region: $REGION"
}

default_domain() {
    az containerapp env show \
        --resource-group $RESOURCES_GROUP \
        --name $APP_ENV \
        --query properties.defaultDomain \
        --output tsv
}

create_container_app() {
    local service=$1
    local target_port=8080

    # Create a Container App
    az containerapp create \
        --resource-group $RESOURCES_GROUP \
        --name $service \
        --environment $APP_ENV \
        --image $ACR_NAME.azurecr.io/$service:v1 \
        --min-replicas 1 \
        --max-replicas 3 \
        --target-port $target_port \
        --ingress external \
        --registry-server $ACR_NAME.azurecr.io \
        --registry-username $ACR_USERNAME \
        --registry-password $ACR_PASSWORD \
        --revisions-mode multiple \
        --cpu 0.25 \
        --memory 0.5Gi \
        --env-vars \
            SERVER_PORT=$target_port \
            PETSTOREAPP_URL=https://petstoreapp.$DOMAIN \
            PETSTOREPETSERVICE_URL=https://petstorepetservice.$DOMAIN \
            PETSTOREPRODUCTSERVICE_URL=https://petstoreproductservice.$DOMAIN \
            PETSTOREORDERSERVICE_URL=https://petstoreorderservice.$DOMAIN \
        || die "Failed to create Container App: $service"
}

# Create a Container App Environment
create_container_app_environment

# Get the defaultDomain of a Container App Environment
export DOMAIN=$(default_domain)

# Create Container Apps for the services
create_container_app petstoreapp
create_container_app petstorepetservice
create_container_app petstoreorderservice
create_container_app petstoreproductservice
