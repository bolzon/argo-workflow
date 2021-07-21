# Argo Workflow (proof of concept)

This POC intends to be an initial point of how to properly configure [Argo Workflow](https://argoproj.github.io/workflows) to run in your local machine or wherever your cluster is.


## Install and configure

Have installed [docker](https://www.docker.com/), [k3s](https://k3s.io/) and [k3d](https://k3d.io/).

Create a cluster using k3d.

```sh
$ k3d cluster create argo-cluster
```

Add the new cluster config to the local one.

```sh
$ k3d kubeconfig merge argo-cluster --kubeconfig-switch-context
```

Check the available nodes.

```sh
$ kubectl get nodes
NAME        STATUS   ROLES                  AGE   VERSION
my-node     Ready    control-plane,master   29h   v1.21.2+k3s1
```

Create a namespace.

```sh
$ kubectl create namespace poc-argo
namespace/poc-argo created
```

Install Argo Workflow applying manifest resources.

```sh
$ NAMESPACE=poc-argo
$ curl https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/install.yaml | sed "s/namespace: argo/namespace: $NAMESPACE/g" | kubectl apply -n poc-argo -f -
```

As it's running locally, need to open the namespace port to be able to access the web portal.

```sh
$ kubectl -n poc-argo port-forward deployment/argo-server 2746:2746
```

After that, endpoint should be ready to access:

**https://localhost:2746**

Update the service to be a `LoadBalancer`.

```sh
$ kubectl patch svc argo-server -n poc-argo -p '{"spec": {"type": "LoadBalancer"}}'
```

Finally, install Argo CLI (Linux ─ for other OS go to releases page).

```sh
$ curl -sL https://github.com/argoproj/argo-workflows/releases/download/v3.1.2/argo-linux-amd64.gz | gzip -d > /tmp/argo && chmod +x /tmp/argo && sudo mv /tmp/argo /usr/local/bin/argo
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

List your workflows.

```sh
$ argo list
```

Submit the first test workflow.

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