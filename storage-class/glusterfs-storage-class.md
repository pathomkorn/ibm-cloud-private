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
* Create PersistentVolumeClaim (PVC) under user namespace.  It will create PersistentVolume (PV) automatically

# Troubleshooting
* List files in PV under pod on ICP worker node
```bash
$ find /var/lib/kubelet/pods/${ICP_POD_ID}/volumes/kubernetes.io~glusterfs/${ICP_PV_NAME}
```
* Map Heketi/Gluster volume name with PVC
```bash
$ df /var/lib/kubelet/pods/${ICP_POD_ID}/volumes/kubernetes.io~glusterfs/${ICP_PV_NAME} | awk '{ print $1 }'
Filesystem
${ICP_GLUSTERFS_SERVER_NODE}:vol_${ICP_HEKETI_VOLUME_ID}
```
* List all Heketi/Gluster volume in Heketi
```bash
$ docker ps | grep heketi | grep -v pause | awk '{ print $1 }'
$ docker exec -it ${ICP_HEKETI_CONTAINER_ID} heketi-cli volume list
Id:${ICP_HEKETI_VOLUME_ID}    Cluster:${ICP_HEKETI_CLUSTER_ID}    Name:vol_${ICP_HEKETI_VOLUME_ID}
```
* List all Heketi/Gluster volume in GlusterFS server
```bash
$ docker ps | grep gluster | grep -v pause | awk '{ print $1 }'
$ docker exec -it ${ICP_GLUSTERFS_CONTAINER_ID} gluster volume list
vol_${ICP_HEKETI_VOLUME_ID}
$ docker exec -it ${ICP_GLUSTERFS_CONTAINER_ID} vol_${ICP_HEKETI_VOLUME_ID}
Status of volume: vol_${ICP_HEKETI_VOLUME_ID}
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick ${ICP_WORKER_NODE_1}:/var/lib/heketi/mounts/vg_XXX/brick_XXX/brick      XXXXX     0          Y       XXXX
Brick ${ICP_WORKER_NODE_2}:/var/lib/heketi/mounts/vg_XXX/brick_XXX/brick      XXXXX     0          Y       XXXX
Self-heal Daemon on ${ICP_WORKER_NODE_1}          N/A       N/A        Y       XXXX
Self-heal Daemon on ${ICP_WORKER_NODE_2}          N/A       N/A        Y       XXXX

Task Status of Volume vol_${ICP_HEKETI_VOLUME_ID}
------------------------------------------------------------------------------
There are no active volume tasks
```
