Check the storageclass for host path provisioner

```
kubectl get sc
```

## Deploy our statefulset

```
kubectl apply -f .\kubernetes\statefulsets\statefulset.yaml
```

## Enable Redis Cluster

```bash
IPs=""

for ip in $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP} '); do
  IPs+="$ip:6379 "
done

IPs=$(echo $IPs | sed 's/ $//')

export IPs
```

```
kubectl exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 --cluster create ${IPs}"
kubectl exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 cluster info"
```


```bash
kubectl apply -f .\kubernetes\statefulsets\example-app.yaml
```

```bash
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                          STORAGECLASS   REASON   AGE
pvc-2166effb-2e0f-4b56-a9df-49a9e03a76b6   50Mi       RWO            Delete           Bound    default/data-redis-cluster-3   local-path              3m20s
pvc-2b9a9c6d-be8d-4ba1-805a-7706c64bd052   50Mi       RWO            Delete           Bound    default/data-redis-cluster-1   local-path              3m50s
pvc-45b051c7-947c-4c85-8a9c-16c34b15421d   50Mi       RWO            Delete           Bound    default/data-redis-cluster-0   local-path              4m6s
pvc-5653d345-1325-468f-bf9f-c1361b6bcb6a   50Mi       RWO            Delete           Bound    default/data-redis-cluster-2   local-path              3m35s
pvc-8a64f910-feab-4dd0-9bc2-e08a82f7e830   50Mi       RWO            Delete           Bound    default/data-redis-cluster-4   local-path              3m4s
pvc-a024f988-9326-4b54-b7ad-ff3726503a3c   50Mi       RWO            Delete           Bound    default/data-redis-cluster-5   local-path              2m48s

kubectl get pvc
NAME                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-redis-cluster-0   Bound    pvc-45b051c7-947c-4c85-8a9c-16c34b15421d   50Mi       RWO            local-path     4m15s
data-redis-cluster-1   Bound    pvc-2b9a9c6d-be8d-4ba1-805a-7706c64bd052   50Mi       RWO            local-path     3m59s
data-redis-cluster-2   Bound    pvc-5653d345-1325-468f-bf9f-c1361b6bcb6a   50Mi       RWO            local-path     3m44s
data-redis-cluster-3   Bound    pvc-2166effb-2e0f-4b56-a9df-49a9e03a76b6   50Mi       RWO            local-path     3m29s
data-redis-cluster-4   Bound    pvc-8a64f910-feab-4dd0-9bc2-e08a82f7e830   50Mi       RWO            local-path     3m14s
data-redis-cluster-5   Bound    pvc-a024f988-9326-4b54-b7ad-ff3726503a3c   50Mi       RWO            local-path     2m57s
```

## More info
https://rancher.com/blog/2019/deploying-redis-cluster
