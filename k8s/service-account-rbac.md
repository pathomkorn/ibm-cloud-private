# Grant RBAC for service account
* Login with user namespace
```bash
kubectl create rolebinding default-admin \ 
  --clusterrole=admin \ 
  --serviceaccount=${K8S_NAMESPACE}:default \ 
  --namespace=${K8S_NAMESPACE}
```
