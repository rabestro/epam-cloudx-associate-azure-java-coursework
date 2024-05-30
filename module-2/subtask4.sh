#
# Subtask 4: Creating a GitHub repository and setting a secret
#

gh auth login --hostname github.com

# Create an empty public repository, set the repository name as "webapp."
# Please don't add README or .gitignore files.

gh repo create webapp \
    --public \
    --license MIT \
    --description "CloudX Assosiate MS Azure Developer Training"

# Please make sure to save the link to your repository

REPO_URL=https://github.com/rabestro/webapp.git

# Click on the "Settings" tab.
# In the left sidebar, under the "Security" section, click on "Secrets and variables" > "Actions."
# Click on the "New repository secret" button.
# Set the name of the secret as "WEBAPPSECRET", enter the value of your Azure Container Registry password
# (password 1) that you saved from Subtask 3, and click "Add secret."

gh repo clone git@github.com:rabestro/webapp.git
cd webapp
gh secret set WEBAPPSECRET --body "$ACR_PASSWORD"
cd ..
