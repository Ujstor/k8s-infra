StorageClasses let you define different classes of storage that apps
can request. How you define your StorageClasses is up to you and will depend on the
types of storage you have available.

Main workflow:

1. A normal Pod object
2. The Pod requests a volume via the mypvc PVC
3. The file defines a PVC called mypvc
4. The PVC provisions a 50Gi volume
5. The volume will be provisioned from the fast StorageClass
6. The file defines the fast StorageClass
7. The StorageClass provisions volumes via the pd.csi.storage.gke.io CSI plugin
8. The CSI plugin will provision fast (pd-ssd) storage from the Google Cloud’s storage backend

```bash
apiVersion: v1
kind: Pod # <<==== 1. Pod
metadata:
  name: mypod
spec:
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: mypvc # <<==== 2. Request volume via the "mypvc" PVC
  containers: ...
  <SNIP>
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc # <<==== 3. This is the "mypvc" PVC
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi # <<==== 4. Provision a 50Gi volume...
  storageClassName: fast # <<==== 5. ...based on the "fast" StorageClass
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast # <<==== 6. This is the "fast" StorageClass
provisioner: pd.csi.storage.gke.io # <<==== 7. Use this CSI plugin
parameters:
  type: pd-ssd # <<==== 8. Provision this type of storage
```
Kubernetes supports three volume access modes:

  - ReadWriteOnce (RWO)
  - ReadWriteMany (RWM)
  - ReadOnlyMany (ROM)

***ReadWriteOnce*** lets a single PVC bind to a volume in read-write (R/W) mode. Attempts
to bind it from multiple PVCs will fail.

***ReadWriteMany*** lets multiple PVCs bind to a volume in read-write (R/W) mode. File and
object storage usually support this mode, whereas block storage usually doesn’t.

***ReadOnlyMany*** allows multiple PVCs to bind to a volume in read-only (R/O) mode.
It’s also important to know that a PV can only be opened in one mode. For example, you
cannot bind a single PV to one PVC in ROM mode and another PVC in RWM mode.
