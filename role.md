# ICP Roles

## Grant Privileged Containers in Non-Default Namespaces

* Verify existing permission to run privileged containers under non-default namespaces

```bash
# NAMESPACE=demo
# kubectl --as=system:serviceaccount:${NAMESPACE}:default -n ${NAMESPACE} auth can-i use podsecuritypolicy/privileged
no
```

* Create role for permitting use of `privileged` pod security policy

```bash
# kubectl -n ${NAMESPACE} create role ${NAMESPACE}:psp:privileged --verb=use --resource=podsecuritypolicy --resource-name=privileged
role "${NAMESPACE}:psp:privileged" created
```

* Apply role to namespace service account

```bash
# kubectl -n ${NAMESPACE} create rolebinding default:psp:privileged --role=${NAMESPACE}:psp:privileged --serviceaccount=${NAMESPACE}:default
rolebinding "default:psp:privileged" created
```

* Verify new permission to run privileged containers under non-default namespaces

```bash
# kubectl --as=system:serviceaccount:${NAMESPACE}:default -n ${NAMESPACE} auth can-i use podsecuritypolicy/privileged
yes
```
