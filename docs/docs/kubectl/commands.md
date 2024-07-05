## kube context

```bash
kubectl config view
kubectl config current-context
kubectl config use-context foo
```

## ns context

```bash
kubectl config set-context --current --namespace bar
```

## Rollouts

```bash
kubectl rollout pause deploy <m-name>
kubectl rollout resume deploy <m-name>
```

```bash
kubectl rollout history deployment <m-name>
kubectl rollout undo deployment <m-name> --to-revision=1
```
