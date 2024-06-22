# Module 4: Container Apps

This module covers the deployment and management of applications using Azure Container Apps.

## Topics Covered

- Deploying Container Apps
- Setting up Autoscaling
- Setting up Multi-revision Deployments
- Conducting Canary and Blue/Green Deployments
- Application Configuration

## Practical Task

The practical task involved deploying a web application called PetStoreApp and its associated services (PetService, ProductService, OrderService) on Azure Container Apps using Docker deployment from Azure Container Registry.

The PetStoreApp and the services were deployed in the same Azure region. Environment variables were set up to enable communication between the web app and the services.

Autoscaling was configured for the services based on concurrent requests. Multi-revision deployments were set up for the web app, and updated versions of the web app were deployed as new revisions. Canary and Blue/Green deployments were conducted to gradually redirect traffic to the new revisions.

## Commands Used

A variety of Azure CLI commands were used to accomplish the task, including `az containerapp create`, `az containerapp update`, `az containerapp autoscale create`, `az containerapp autoscale rule create`, `az containerapp revision create`, and `az containerapp revision traffic update`.

## Learnings

Through this module, I learned how to deploy and manage applications on Azure Container Apps, how to set up autoscaling and multi-revision deployments, and how to conduct Canary and Blue/Green deployments. I also gained hands-on experience with Azure CLI and Azure Container Registry.
