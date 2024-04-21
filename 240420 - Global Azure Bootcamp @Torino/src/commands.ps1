$SUBSCRIPTION=""
$RESOURCE_GROUP="gab2024"
$LOCATION="francecentral"
$CONTAINERAPPS_ENVIRONMENT="gab2024-env"

az account set --subscription $SUBSCRIPTION

# Create the backend storage
$STORAGE_ACCOUNT="gab2024run"

# Create the storage account with the parameters
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --location $LOCATION --sku Standard_LRS
$STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
