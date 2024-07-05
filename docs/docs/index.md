# Local kubernetes cluster

For testing pupose, you can use [k3d](https://github.com/k3d-io/k3d):

```bash
k3d cluster create k8s-test \
  --servers 3 \
  --agents 3 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  --k3s-node-label "type=control@server:0,1,2" \
  --k3s-node-label "type=worker@agent:0,1,2"
```

## Cluster overview

![Control Plane Node](./public/01_control_plane_node.png)

![Worker Node](./public/02_worker_node.png)

![Different Workloads Pod](./public/03_diff_workloads_pod.png)

![Pod Network](./public/05_pod_network.png)

## CP controllers

In Kubernetes the control plane is the central management entity that manages the state of the Kubernetes cluster. It consists of several key components, including various controllers that ensure the desired state of the cluster is maintained. Here are some of the primary types of controllers in the Kubernetes control plane:

1. **Replication Controller**:
    Ensures that a specified number of pod replicas are running at any given time. If there are too few replicas, it creates more; if there are too many, it deletes some.

2. **Deployment Controller**:
    Manages Deployment resources to provide declarative updates to applications. It can roll back changes, perform rolling updates, and handle scaling.

3. **StatefulSet Controller**:
    Manages StatefulSet resources, providing guarantees about the ordering and uniqueness of pods. This is useful for applications that require stable, unique network identifiers or persistent storage.

4. **DaemonSet Controller**:
    Ensures that a copy of a pod is running on all (or some) nodes. This is often used for running cluster-wide services like logging and monitoring agents.

5. **Job Controller**:
    Manages Job resources, which run a specified number of pod completions and ensure that a specified number of them successfully terminate. This is typically used for batch processing.

6. **CronJob Controller**:
    Manages CronJob resources, which create Jobs on a time-based schedule.

7. **ReplicaSet Controller**:
    Ensures that a specified number of pod replicas are running. It's similar to the Replication Controller but supports set-based label selectors. ReplicaSets are primarily used by Deployments.

8. **Service Controller**:
    Manages Service resources, ensuring that the correct network endpoints are set up to route traffic to the appropriate pods.

9. **Ingress Controller**:
    Manages Ingress resources, providing HTTP and HTTPS routing to services within the cluster based on hostnames and paths.

10. **Node Controller**:
    Manages various aspects of nodes, including node status updates, node lifecycle management, and running node-specific operations.

11. **Endpoint Controller**:
     Manages Endpoints resources, updating the list of endpoints in a Service whenever the set of pods in a Service changes.

12. **Namespace Controller**:
     Manages namespace resources, handling cleanup of resources when a namespace is deleted.

13. **ServiceAccount Controller**:
     Manages ServiceAccount resources, ensuring that default service accounts are created for new namespaces and tokens are created for service accounts.

14. **PersistentVolume (PV) Controller**:
     Manages PersistentVolume resources, ensuring that persistent storage is available for use by PersistentVolumeClaim resources.

15. **PersistentVolumeClaim (PVC) Controller**:
     Manages PersistentVolumeClaim resources, binding them to appropriate PersistentVolume resources.

16. **Horizontal Pod Autoscaler (HPA) Controller**:
     Manages HorizontalPodAutoscaler resources, which automatically scale the number of pods in a deployment, replica set, or stateful set based on observed CPU utilization (or other select metrics).

These controllers work together to ensure that the Kubernetes cluster functions smoothly, automating tasks like scaling, self-healing, and rolling updates to maintain the desired state specified by the user.

