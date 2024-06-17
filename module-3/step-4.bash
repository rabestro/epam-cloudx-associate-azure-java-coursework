# Step 4: Configure Auto-Scaling

# Create an auto-scale condition
# az monitor autoscale condition create \
#     --resource-group $RESOURCES_GROUP \
#     --scale-set petstorepetservice \
#     --condition "Percentage CPU > 70 avg 5m"

# Create an auto-scale rule
# az monitor autoscale rule create \
#     --resource-group $RESOURCES_GROUP \
#     --scale-set petstorepetservice \
#     --scale out 1 \
#     --condition "Percentage CPU > 70 avg 5m"

# az monitor autoscale create \
#     --count 1 --min-count 1 --max-count 5 \
#     --name MyAutoscaleSettings \
#     --resource petstorepetservice-eastus \
#     --resource-group $RESOURCES_GROUP \
#     --resource-type Microsoft.Web/sites


RESOURCES_GROUP=module3_rg
WEBAPPS=(petstorepetservice-eastus petstoreproductservice-eastus petstoreorderservice-eastus)

# for WEBAPP in ${WEBAPPS[@]}
# do
#   # Create an auto-scale setting
#   az monitor autoscale create \
#     --resource-group $RESOURCES_GROUP \
#     --resource $WEBAPP \
#     --resource-type Microsoft.Web/sites \
#     --name autoscale-setting
#
#   # Create a rule to scale out
#   az monitor autoscale rule create \
#     --resource-group $RESOURCES_GROUP \
#     --autoscale-name autoscale-setting \
#     --name scale-out-rule \
#     --condition "Percentage CPU > 70 avg 5m" \
#     --scale out 1
#
#   # Create a rule to scale in
#   az monitor autoscale rule create \
#     --resource-group $RESOURCES_GROUP \
#     --autoscale-name autoscale-setting \
#     --name scale-in-rule \
#     --condition "Percentage CPU < 25 avg 5m" \
#     --scale in 1
# done

k6 run constant-load.js
k6 run gradual-rampup.js
k6 run sudden-spike.js
