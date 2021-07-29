# Argo Workflow (proof of concept)

This POC intends to be an initial point of how to properly configure [Argo Workflow](https://argoproj.github.io/workflows) to run in your local machine or wherever your cluster is.


## Install and configure

Have installed [docker](https://www.docker.com/), [minikube](https://minikube.sigs.k8s.io/docs/start/) and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

Start the cluster.

```sh
$ minikube start
```

Create a namespace.

```sh
$ kubectl create namespace poc-argo
namespace/poc-argo created
```

Install Argo Workflow applying manifest.

```sh
$ kubectl apply -n poc-argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/namespace-install.yaml
```

Create role binding.

```sh
$ kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=poc-argo:default --namespace=poc-argo
```

Open the namespace port to be able to access the web portal.

```sh
$ kubectl -n poc-argo port-forward deployment/argo-server 2746:2746
```

After that, endpoint should be ready to access:

**https://localhost:2746**

Finally, install Argo CLI (Linux ─ for other OS go to releases page).

```sh
$ curl -sL https://github.com/argoproj/argo-workflows/releases/download/v3.1.2/argo-linux-amd64.gz | gzip -d > /tmp/argo && chmod +x /tmp/argo && sudo mv /tmp/argo /usr/local/bin/argo
```

Configure your CLI to point to the Argo server.

```sh
export ARGO_SERVER='localhost:2746'
export ARGO_HTTP1=true
export ARGO_SECURE=true
export ARGO_INSECURE_SKIP_VERIFY=true
export ARGO_BASE_HREF=
export ARGO_TOKEN=''
export ARGO_NAMESPACE=poc-argo
```

Check if it's working.

```sh
$ argo version
argo: v3.1.2
  BuildDate: 2021-07-15T21:53:44Z
  GitCommit: 98721a96eef8e4fe9a237b2105ba299a65eaea9a
  GitTreeState: clean
  GitTag: v3.1.2
  GoVersion: go1.15.7
  Compiler: gc
  Platform: linux/amd64
argo-server: v3.0.3
  BuildDate: 2021-05-11T21:18:51Z
  GitCommit: 02071057c082cf295ab8da68f1b2027ff8762b5a
  GitTreeState: clean
  GitTag: v3.0.3
  GoVersion: go1.15.7
  Compiler: gc
  Platform: linux/amd64
```

List your workflows.

```sh
$ argo list -n poc-argo
```

Submit the first test workflow and watch until completion.

```sh
$ argo submit -n poc-argo --watch https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml
```


## Manifest examples

There are a bunch of manifest examples in this repo.

https://github.com/argoproj/argo-workflows/tree/master/examples


## References

- Take Argo CD for a spin with K3s and k3d  
  https://thecloud.christmas/2020/13

- Install Argo Workflows  
  https://github.com/argoproj/argo-workflows/blob/master/docs/quick-start.md
