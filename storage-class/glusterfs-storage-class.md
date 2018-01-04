# Create GlusterFS Storage Class
* Get Heketi service port
```bash
$ kubectl get svc heketi -n kube-system -o=jsonpath='{.spec.ports[0].nodePort}'; echo ''
```
* Download and edit glusterfs-storage-class.yaml
* Add GlusterFS storage class
```bash
$ kubectl delete storageclass glusterfs-distributed
$ kubectl create -f glusterfs-storage-class.yaml
$ kubectl patch storageclass glusterfs-distributed -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
$ kubectl get storageclasses
$ kubectl get storageclasses glusterfs-distributed -o yaml
```
