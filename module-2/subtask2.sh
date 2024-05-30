#
# Subtask 2: Resource Groups
#

PERMANENT_GROUP=permanent_rg
PERMANENT_LOCATION=eastus
TEMPORARY_GROUP=temporary_rg
TEMPORARY_LOCATION=westeurope

# Use the az group create command along with the variables to create a permanent and a temporary resource groups.

az group create --name $PERMANENT_GROUP --location $PERMANENT_LOCATION
az group create --name $TEMPORARY_GROUP --location $TEMPORARY_LOCATION

# Use the az group list command to list all available resource groups in your subscription.

az group list

# Change the previous command to get a table.

az group list --output table

# Use the az group show command to output detailed information about the permanent resource group.

az group show --name $PERMANENT_GROUP

# Use the az group list command to list as a table and filter resource groups,
# using the variable in which you stored the location of the permanent resource group.

az group list \
    --output table \
    --query "[?location=='$PERMANENT_LOCATION'].{Name:name, Location:location}"

# Use the az group show command to save the permanent resource group ID to a variable and output it.

GROUP_ID=$(az group show --name $PERMANENT_GROUP --query "id" --output tsv)
echo $GROUP_ID

# Use the az group delete command along with the variable containing
# the name of the temporary resource group to delete it. Use a necessary option
# to do it without being prompted for additional confirmation.

az group delete --name $TEMPORARY_GROUP --yes --no-wait

# Check if the temporary resource group has been deleted.

az group list --output table
