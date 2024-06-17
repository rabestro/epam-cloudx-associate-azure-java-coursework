# Module 3: App Service

This module covers the deployment and management of applications using Azure App Service.

## Topics Covered

- Deploying App Service
- Setting up Autoscaling
- Setting up Deployment Slots
- Configuring Traffic Manager
- Application Configuration

## Practical Task

The practical task involved deploying a web application called PetStoreApp and its associated services (PetService, ProductService, OrderService) on Azure App Services using Docker deployment from Azure Container Registry.

The PetStoreApp was deployed in two different regions, and the services were deployed in one region. Environment variables were set up to enable communication between the web app and the services.

Autoscaling was configured for the services based on CPU load increase. Deployment slots were set up for the web app, and Traffic Manager was configured to direct traffic to the two instances of the web app.

## Commands Used

A variety of Azure CLI commands were used to accomplish the task, including `az acr login`, `az acr build`, `az appservice plan create`, `az webapp create`, `az webapp config appsettings set`, `az monitor autoscale create`, `az monitor autoscale rule create`, `az webapp deployment slot create`, `az network traffic-manager profile create`, and `az network traffic-manager endpoint create`.

## Learnings

Through this module, I learned how to deploy and manage applications on Azure App Service, how to set up autoscaling and deployment slots, and how to configure Traffic Manager for routing traffic. I also gained hands-on experience with Azure CLI and Azure Container Registry.
