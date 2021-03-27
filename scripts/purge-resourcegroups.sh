
export rg_prefix_name=$1
#for i in `az group list -o tsv --query "[?contains(name, '${rg_prefix_name}')].name"`; do echo "purging resource groups: $i" && $(az group delete --name $i --yes); done
echo "removing $1 footprint"
for i in `az monitor diagnostic-settings subscription list -o tsv --query "value[?contains(name, '${rg_prefix_name}' )].name"`; do echo "purging subscription diagnostic-settings: $i" && $(az monitor diagnostic-settings subscription delete --name $i --yes); done
for i in `az monitor log-profiles list -o tsv --query '[].name'`; do az monitor log-profiles delete --name $i; done
for i in `az ad group list --query "[?contains(displayName, '${rg_prefix_name}')].objectId" -o tsv`; do echo "purging Azure AD group: $i" && $(az ad group delete --verbose --group $i || true); done
for i in `az ad app list --query "[?contains(displayName, '${rg_prefix_name}')].appId" -o tsv`; do echo "purging Azure AD app: $i" && $(az ad app delete --verbose --id $i || true); done
for i in `az keyvault list-deleted --query "[?tags.environment=='${rg_prefix_name}'].name" -o tsv`; do az keyvault purge --name $i; done
for i in `az group list --query "[?tags.environment=='${rg_prefix_name}'].name" -o tsv`; do echo "purging resource group: $i" && $(az group delete -n $i -y --no-wait || true); done
for i in `az role assignment list --query "[?contains(roleDefinitionName, '${rg_prefix_name}')].roleDefinitionName" -o tsv`; do echo "purging role assignment: $i" && $(az role assignment delete --role $i || true); done
for i in `az role definition list --query "[?contains(roleName, '${rg_prefix_name}')].roleName" -o tsv`; do echo "purging custom role definition: $i" && $(az role definition delete --name $i || true); done


