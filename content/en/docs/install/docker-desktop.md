---
title: Installing on Docker Desktop
description: This tutorial shows how to install SpinKube with Docker Desktop.
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
---

[Docker Desktop](https://docs.docker.com/desktop/) is an open-source application that provides all
the essentials to work with containers and Kubernetes on your desktop.

## Prerequisites

For this guide, you will need:

- [Docker Desktop](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - the Kubernetes CLI
- [Helm](https://helm.sh/docs/intro/install/) - the package manager for Kubernetes
- [`spin kube`]({{< ref "spin-kube-plugin" >}}) - the Kubernetes plugin for Spin
- An account on [Docker Hub](https://hub.docker.com/) or another container registry

### Enable Webassembly support

WebAssembly (Wasm) support is still an in-development (Beta) feature of Docker Desktop. Wasm support
is disabled by default. To turn it on, open your Docker Desktop settings menu and click the gear
icon in the top right corner of the navigation bar. Click Extensions from the menu on the left and
ensure that boxes relating to Docker Marketplace and Docker Extensions system containers are checked
(as shown in the image below). Checking these boxes enables the "Features in development" extension.

![Docker Desktop Extensions](/docker-desktop-extensions.png)

Please ensure that you press "Apply & restart" to save any changes.

Click on Features in development from the menu on the left, and enable the following two options:

- "Use containerd for pulling and storing images": This turns on `containerd` support, which is
  necessary for Wasm.
- "Enable Wasm": This installs the Wasm subsystem, which includes `containerd` shims and Spin (among
  other things).

![Docker Desktop Enable Wasm](/docker-desktop-enable-wasm.png)

Make sure you press "Apply & restart" to save the changes.

Docker Desktop is Wasm-ready!

Click on "Kubernetes" and check the "Enable Kubernetes" box, as shown below.

![Enable Kubernetes](/docker-desktop-enable-kubernetes.png)

Make sure you press "Apply & restart" to save the changes.

Select docker-desktop from the Kubernetes Contexts configuration in your toolbar.

![Kubernetes Context](/docker-desktop-context.png)

## Install SpinKube

The following commands are from the [Quickstart guide]({{< ref "quickstart" >}}). Please refer to
the guide if you have any questions.

The following commands install all of the necessary items that can be found in the quickstart:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager-webhook -n cert-manager
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.2.0/spin-operator.crds.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.2.0/spin-operator.runtime-class.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.2.0/spin-operator.shim-executor.yaml

helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --version 0.2.0 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator

helm repo add kwasm http://kwasm.sh/kwasm-operator/

helm install \
  kwasm-operator kwasm/kwasm-operator \
  --namespace kwasm \
  --create-namespace \
  --set kwasmOperator.installerImage=ghcr.io/spinkube/containerd-shim-spin/node-installer:v0.15.1

kubectl annotate node --all kwasm.sh/kwasm-node=true
```

## Scaffold a new application

Next, we create a new application using the Javascript template:

```bash
spin new -t http-js hello-docker --accept-defaults
cd hello-docker
npm install
```

We then edit the Javascript source file (the `src/index.js` file) to match the following:

```javascript
export async function handleRequest(request) {
    return {
        status: 200,
        headers: {"content-type": "text/plain"},
        body: "Hello from Docker Desktop" // <-- This changed
    }
}
```

All that’s left to do is build the app:

```bash
spin build
```

## Deploying our application to SpinKube

First we must log into our container registry. In this example, we'll be using Docker Hub:

```bash
spin registry login docker.io
```

Now we can publish our application using the `spin registry push` command:

```bash
spin registry push tpmccallum/hello-docker
```

The command above will return output similar to the following:

```bash
Using default tag: latest
The push refers to repository [docker.io/tpmccallum/hello-docker]
latest: digest: sha256:f24bf4fae2dc7dd80cad25b3d3a6bceb566b257c03b7ff5b9dd9fe36b05f06e0 size: 695
```

Once published, we can generate a SpinApp manifest of our published application using the `spin kube
scaffold` command:

```bash
spin kube scaffold --from tpmccallum/hello-docker --out hello-docker.yaml
```

If we read `hello-docker.yaml`, it will return something similar to the following YAML:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: hello-docker
spec:
  image: "tpmccallum/hello-docker"
  executor: containerd-shim-spin
  replicas: 2
```

We can run this using the following command:

```bash
kubectl apply -f hello-docker.yaml
```

If we look at the "Images" section of Docker Desktop we see `tpmccallum/hello-docker`:

![Docker Desktop Images](/docker-desktop-images.png)

We can test the Wasm-powered Spin app that is running via Docker using the following request:

```bash
curl localhost:3000
```

Which returns the following:

```bash
Hello from Docker Desktop
```
