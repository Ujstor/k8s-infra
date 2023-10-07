`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml`

`kubectl create serviceaccount dashboard -n kubernetes-dashboard`

`kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode`

`kubectl create clusterrolebinding dashboard-admin -n kubernetes-dashboard  --clusterrole=cluster-admin  --serviceaccount=default:dashboard`

`kubectl secret generic basic-auth --from-file=auth`
