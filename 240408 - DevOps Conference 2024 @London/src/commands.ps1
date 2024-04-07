$SUBSCRIPTION=""
$RESOURCE_GROUP="Containers"
$LOCATION="francecentral"
$CONTAINERAPPS_ENVIRONMENT="sla24-aca"

az account set --subscription $SUBSCRIPTION


# Create the backend storage
$STORAGE_ACCOUNT="sla24storage01"
$STORAGE_SHARE="stateshare"

# Create the storage account with the parameters
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --location $LOCATION --sku Standard_LRS
$STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)

# Create the file share
az storage share create --name $STORAGE_SHARE --account-name $STORAGE_ACCOUNT

# Create the ACI with volume mount
az container create --resource-group $RESOURCE_GROUP --name sample-app --image nginx:latest `
            --dns-name-label sample-app --ports 80 --azure-file-volume-account-name $STORAGE_ACCOUNT `
            --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name $STORAGE_SHARE --azure-file-volume-mount-path /usr/share/nginx/html

#This won't work due to missing subPath
az container create --resource-group $RESOURCE_GROUP --name librechat --image ghcr.io/danny-avila/librechat:v0.6.10 `
            --dns-name-label librechat --ports 80 --azure-file-volume-account-name $STORAGE_ACCOUNT `
            --azure-file-volume-account-key $STORAGE_KEY --azure-file-volume-share-name $STORAGE_SHARE --azure-file-volume-mount-path /app/.env



# Create the ACA Environment
az containerapp env create --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --location $LOCATION `
    --enable-workload-profiles true  --internal-only false  --logs-destination none

