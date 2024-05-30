#
# Subtask 5: CI/CD to Azure Container Registry with GitHub Actions
#

# curl --location \
# https://git.epam.com/epm-cdp/cloudx-assosiate-ms-azure-developer/cloudx-java-azure-dev/-/raw/main/content/modules/module-02-introduction/attachment/webapp.zip?inline=false

echo "Download webapp.zip and press ENTER"
read -s -n 1
unzip webapp.zip

echo "Update the environment variables with your values and press ENTER"
read -s -n 1

git add .
git commit -m "Initial commit"
git branch -M master
git push -u origin master

# Use the az acr repository list command to list the repositories in "yourcontainerregistry".
# Use the proper option to get a table.

az acr repository list --name $ACR_NAME --output table

# Use the az acr repository show-tags command to display the Docker image tags for the "webapp" repository.

az acr repository show-tags --name $ACR_NAME --repository webapp --output table

# Use the az acr repository show-tags command with --orderby time_desc option to find the oldest image.

OLDEST_IMAGE=$(az acr repository show-tags \
    --name $ACR_NAME \
    --repository webapp \
    --orderby time_desc \
    --output table | tail -n 1)

# Use the az acr repository delete command with the full SHA of the oldest image

az acr repository delete --name $ACR_NAME --image webapp:$OLDEST_IMAGE --yes

# Recheck that the oldest image has been deleted

az acr repository show-tags \
    --name $ACR_NAME \
    --repository webapp \
    --orderby time_desc \
    --output table
