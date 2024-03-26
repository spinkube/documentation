---
title: Integrating With Rancher Desktop
description: This tutorial shows how to integrate SpinKube and Rancher Desktop
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

[Rancher Desktop](https://rancherdesktop.io/) is an open-source application that provides all the essentials to work with containers and Kubernetes on your desktop.

## Prerequisites

The prerequisites for this tutorial are Rancher Desktop and assets listed in the SpinKube quickstart. Let's dive in.

### Rancher Desktop

First, install the latest version of [Rancher Desktop](https://rancherdesktop.io/).

### Rancher Desktop Preferences

Check the "Container Engine" section of your "Preferences" to ensure that `containerd` is your runtime and that "Wasm" is enabled. As shown below.

![Rancher Desktop Preferences Wasm](/rancher-desktop-preferences-wasm.png)

Also, select `rancher-desktop` from the `Kubernetes Contexts` configuration in your toolbar.

![Rancher Desktop Preferences Wasm](/rancher-desktop-preferences-toolbar.png)

### SpinKube

The following commands are from the [SpinKube Quickstart guide]({{< ref "/docs/spin-operator/quickstart" >}}). Please refer to the quickstart if you have any queries.

The following commands install all of the necessary items that can be found in the quickstart:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.crds.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.runtime-class.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.shim-executor.yaml

helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --version 0.1.0 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator
helm repo add kwasm http://kwasm.sh/kwasm-operator/

helm install \
  kwasm-operator kwasm/kwasm-operator \
  --namespace kwasm \
  --create-namespace \
  --set kwasmOperator.installerImage=ghcr.io/spinkube/containerd-shim-spin/node-installer:v0.13.1

kubectl annotate node --all kwasm.sh/kwasm-node=true
```

## Creating Our Spin Application

Next, we create a new Spin app using the Javascript template:

```bash
spin new -t http-js hello-k3s --accept-defaults
cd hello-k3s
npm install
```

We then edit the Javascript source file (the `src/index.js` file) to match the following:

```javascript
export async function handleRequest(request) {
    return {
        status: 200,
        headers: {"content-type": "text/plain"},
        body: "Hello from Rancher Desktop" // <-- This changed
    }
}
```

All that’s left to do is build the app:

```bash
spin build
```

## Deploying Our Spin App to Rancher Desktop with SpinKube

We publish our application using the `spin registry` command:

```bash
spin registry push ttl.sh/hello-k3s:0.1.0
```

Once published, we can read the configuration of our published application using the `spin kube scaffold` command:

```bash
spin kube scaffold --from ttl.sh/hello-k3s:0.1.0
```

The above command will return something similar to the following YAML:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: hello-k3s
spec:
  image: "ttl.sh/hello-k3s:0.1.0"
  executor: containerd-shim-spin
  replicas: 2
```

Now, we can deploy the app into our cluster:

```bash
spin kube deploy --from ttl.sh/hello-k3s:0.1.0
```

If we click on the Rancher Desktop’s “Cluster Dashboard”, we can see hello-k3s:0.1.0 running inside the “Workloads” dropdown section:

![Rancher Desktop Preferences Wasm](/rancher-desktop-cluster.png)

To access our app outside of the cluster, we can forward the port so that we access the application from our host machine:

```bash
kubectl port-forward svc/hello-k3s 8083:80
```

To test locally, we can make a request as follows:

```bash
curl localhost:8083
```

The above `curl` command will return the following:

```bash
Hello from Rancher Desktop
```