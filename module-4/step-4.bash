# Module 4: Container Apps
# Step 4: Configure Autoscaling

MODULE=module4
export RESOURCES_GROUP=rg-$MODULE

# Configure autoscaling for a Container App
configure_autoscaling() {
    local service=$1

    az containerapp update \
        --resource-group $RESOURCES_GROUP \
        --name $service \
        --min-replicas 1 \
        --max-replicas 8 \
        --scale-rule-name petstore-autoscaler \
        --scale-rule-http-concurrency 2
}

# Configure autoscaling for the services
configure_autoscaling petstoreapp
configure_autoscaling petstorepetservice
configure_autoscaling petstoreorderservice
configure_autoscaling petstoreproductservice
