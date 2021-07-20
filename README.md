# Argo Workflow (proof of concept)

This POC intends to be an initial point of how to properly configure Argo Workflow to run in your local machine or wherever your cluster is.

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
$ curl https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/install.yaml | sed "s/namespace: argo/namespace: $NAMESPACE/g" | kubectl apply -n poc-argo -f -
```

Configure port forwarding.

```sh
$ kubectl -n poc-argo port-forward deployment/argo-server 2746:2746
```

Access