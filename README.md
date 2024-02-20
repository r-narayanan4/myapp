## markerble assingment

[link-for-assingment](https://docs.google.com/document/u/0/d/15S3BIdAd057s88D310X2UjNnVGozZicrGNHB7UV3uPo/mobilebasic
)

Command to start minikube

```bash
minikube start --driver=virtualbox --no-vtx-check --cpus=4 
```

Command to change the hosts in windows

```bash
notepad C:\Windows\System32\drivers\etc\hosts
```

Example ruby application:

[myapp](https://github.com/r-narayanan4/myapp.git)

Step1: Containerize Docker app

clone the repo **myapp**

Run the following commands:

```bash
cd myapp

docker-compose up 
```

step2: Kubernetes

Install ingress for minikube

```bash
minikube addons enable ingress
kubectl get pods -n ingress-nginx
```

Run Kubernetes files

```bash

kubectl apply -f namespace.yml

kubectl apply -f configmap.yml

kubectl apply -f secret.yml 

kubectl apply -f postgres-statefullset.yml 

kubectl apply -f ruby-app-deployment-service.yml 

kubectl apply -f ruby-ingress.yml 

```

Step3: Argocd

Install argocd

```bash

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

```

Port Forwarding

```bash

kubectl port-forward svc/argocd-server -n argocd 8080:443

```

Login Using The CLI

```bash
argocd admin initial-password -n argocd
```

Login for firts time

```bash
argocd login localhost:8080 --username admin --password passwd --insecure
```

To update passwd

```bash
argocd account update-password
```

Applying argocd files we need to give passwd for new users

```bash
kubectl apply -f application.yml  

kubectl apply -f argocd-cm.yml

kubectl apply -f argocd-rbac-cm.yml 

kubectl apply -f argocd-repo-cred.yml 
```

After that we need give password for users we created in argocd

```bash
argocd account update-password --account support-team --new-password support123

argocd account update-password --account devops-team --new-password devops123
```

step4:Tekton pipeline

To install tekton pipleine

```bash
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

Install tekton dashboard read and write

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml
```

Accessing the Dashboard

Using kubectl port-forward

```bash
kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
```

Grant required permissions

```bash
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: tekton-dashboard-tutorial
rules:
  - apiGroups:
      - tekton.dev
    resources:
      - tasks
      - taskruns
      - pipelines
      - pipelineruns
    verbs:
      - get
      - create
      - update
      - patch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: tekton-dashboard-tutorial
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-tutorial
subjects:
  - kind: ServiceAccount
    name: default
    namespace: tekton-dashboard
EOF
```

To install tkn cli in powershell

```powershell
#Create directory
New-Item -Path "$HOME/tektoncd/cli" -Type Directory
# Download file
Start-BitsTransfer -Source https://github.com/tektoncd/cli/releases/download/v0.35.1/tkn_0.35.1_Windows_x86_64.zip -Destination "$HOME/tektoncd/cli/."
# Uncompress zip file
Expand-Archive $HOME/tektoncd/cli/*.zip -DestinationPath C:\Users\Developer\tektoncd\cli\.
#Add to Windows `Environment Variables`
[Environment]::SetEnvironmentVariable("Path",$($env:Path + ";$Home\tektoncd\cli"),'User')
```

Create secret for dockerhub

```bash
kubectl create secret docker-registry private-registry --docker-server=https://index.docker.io/v1/ --docker-username=rln410 --docker-password=rlnrlnRLN
```

Create serviceaccount

```bash
cat <<"EOF" | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pipeline-runner
secrets:
- name: private-registry
EOF
```

Import tasks

```bash
tkn hub install task git-clone

tkn hub install task kaniko
```

Import the source from tekton dashboard



