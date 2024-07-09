```bash
kubectl get all -A

kube-system  service/traefik  LoadBalancer 10.43.123.79  172.19.0.2,172.19.0.3,172.19.0.4,172.19.0.5,172.19.0.6,172.19.0.7   80:31183/TCP,443:31980/TCP   53s
```

### /etc/hosts

```bash
172.19.0.2	cluster.xyz		
172.19.0.2	hydra.cluster.xyz	
172.19.0.2	shield.cluster.xyz	
```

### Ingress

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  annotations:
    treafik.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: traefik
  rules:
  - host: shield.cluster.xyz
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: svc-shield
            port:
              number: 8080
  - host: hydra.cluster.xyz
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: svc-hydra
            port:
              number: 8080
  - host: cluster.xyz
    http:
      paths:
      - path: /shield
        pathType: Prefix
        backend:
          service:
            name: svc-shield
            port:
              number: 8080
      - path: /hydra
        pathType: Prefix
        backend:
          service:
            name: svc-hydra
            port:
              number: 8080
```
