kubectl create namespace jenkins

kubectl apply -f jenkins-serviceaccount.yaml

kubectl apply -f jenkins-deployment.yaml

kubectl apply -f jenkins-ingress.yaml

kubectl logs jenkins-deployment

http://jenkins-service.jenkins.svc.cluster.local:8080