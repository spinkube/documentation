---
title: Package and Deploy Spin Apps
description: A short lead description about this content page. It can be **bold** or _italic_ and can be split over multiple paragraphs.
date: 2024-02-16
weight: 4
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

This article explains how Spin Apps are packaged and distributed via both public and private registries. You will learn how to:

- Package and distribute Spin Apps
- Deploy Spin Apps
- Scaffold Kubernetes Manifests for Spin Apps
- Use private registries that require authentication

## Prerequisites

Ensure the necessary [prerequisites]({{< ref "prerequisites" >}}) are installed.

For this tutorial in particular, you need

- Spin Operator [running locally]({{< ref "running-locally" >}}) or [running on your Kubernetes cluster]({{< ref "running-on-a-cluster" >}})
- [TinyGo]({{< ref "prerequisites#tinygo" >}}) - for building the Spin app
- [kubectl]({{< ref "prerequisites#kubectl" >}}) - the Kubernetes CLI
- [spin]({{< ref "prerequisites#spin-cli" >}}) - the Spin CLI
- [spin plugin k8s](/docs/spin-plugin-k8s/installation) - the Kubernetes plugin for `spin`

## Creating a new Spin App

You use the `spin` CLI, to create a new Spin App. The `spin` CLI provides different templates, which you can use to quickly create different kinds of Spin Apps. For demonstration purposes, you will use the `http-go` template to create a simple Spin App.

```shell
# Create a new Spin App using the http-go template
spin new --accept-defaults -t http-go hello-spin

# Navigate into the hello-spin directory
cd hello-spin
```

The `spin` CLI created all necessary files within `hello-spin`. Besides the Spin Manifest (`spin.toml`), you can find the actual implementation of the app in `main.go`:

```go
package main

import (
	"fmt"
	"net/http"

	spinhttp "github.com/fermyon/spin/sdk/go/v2/http"
)

func init() {
	spinhttp.Handle(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprintln(w, "Hello Fermyon!")
	})
}

func main() {}
```

This implementation will respond to any incoming HTTP request, and return an HTTP response with a status code of 200 (`Ok`) and send `Hello Fermyon` as the response body.

You can test the app on your local machine by invoking the `spin up` command from within the `hello-spin` folder.

## Packaging and Distributing Spin Apps

Spin Apps are packaged and distributed as OCI artifacts. By leveraging OCI artifacts, Spin Apps can be distributed using any registry that implements the [Open Container Initiative Distribution Specification](https://github.com/opencontainers/distribution-spec) (a.k.a. "OCI Distribution Spec").

The `spin` CLI simplifies packaging and distribution of Spin Apps and provides an atomic command for this (`spin registry push`). You can package and distribute the `hello-spin` app that you created as part of the previous section like this:

```shell
# Package and Distribute the hello-spin app
spin registry push --build ttl.sh/hello-spin:24h
```

> It is a good practice to add the `--build` flag to `spin registry push`. It prevents you from accidentally pushing an outdated version of your Spin App to your registry of choice.

## Deploying Spin Apps

To deploy Spin Apps to a Kubernetes cluster which has Spin Operator running, you use the `k8s` plugin for `spin`. Use the `spin k8s deploy` command as shown here to deploy the `hello-spin` app to your Kubernetes cluster:

```shell
# Deploy the hello-spin app to your Kubernetes Cluster
spin k8s deploy --from ttl.sh/hello-spin:24h

spinapp.core.spinoperator.dev/hello-spin created
```

## Scaffolding Spin Apps

In the previous section, you deployed the `hello-spin` app using the `spin k8s deploy` command. Although this is handy, you may want to inspect, or alter the Kubernetes manifests before applying them. You use the `spin k8s scaffold` command to generate Kubernetes manifests:

```shell
spin k8s scaffold --from ttl.sh/hello-spin:24h
apiVersion: core.spinoperator.dev/v1
kind: SpinApp
metadata:
  name: hello-spin
spec:
  image: "ttl.sh/hello-spin:24h"
  replicas: 2
```

By default, the command will print all Kubernetes menifests to `STDOUT`. Alternatively, you can specify the `out` argument to store the manifests to a file:

```shell
# Scaffold manifests to spinapp.yaml
spin k8s scaffold --from ttl.sh/hello-spin:24h \
    --out spinapp.yaml

# Print contents of spinapp.yaml
cat spinapp.yaml
apiVersion: core.spinoperator.dev/v1
kind: SpinApp
metadata:
  name: hello-spin
spec:
  image: "ttl.sh/hello-spin:24h"
  replicas: 2
```

## Distributing and Deploying Spin Apps via private registries

It is quite common to distribute Spin Apps through private registries that require some sort of authentication. To publish a Spin App to a private registry, you have to authenticate using the `spin registry login` command.

For demonstration purposes, you will now distribute the Spin App via GitHub Container Registry (GHCR). You can follow [this guide by GitHub](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic) to create a new personal access token (PAT), which is required for authentication.

```shell
# Store PAT and GitHub username as environment variables
export CR_PAT=YOUR_TOKEN
export GH_USER=YOUR_GITHUB_USERNAME

# Authenticate spin CLI with GHCR
echo $GH_PAT | spin registry login ghcr.io -u $GH_USER --password-stdin

Successfully logged in as YOUR_GITHUB_USERNAME to registry ghcr.io
```

Once authentication succeeded, you can use `spin registry push` to push your Spin App to GHCR:

```shell
# Push hello-spin to GHCR
spin registry push --build ghcr.io/$GH_USER/hello-spin:0.0.1

Pushing app to the Registry...
Pushed with digest sha256:1611d51b296574f74b99df1391e2dc65f210e9ea695fbbce34d770ecfcfba581
```

In Kubernetes you store authentication information as secret of type `docker-registry`. The following snippet shows how to create such a secret with `kubectl` leveraging the environment variables, you specified in the previous section:

```shell
# Create Secret in Kubernetes
kubectl create secret docker-registry ghcr \
    --docker-server ghcr.io \
    --docker-username $GH_USER \
    --docker-password $CR_PAT

secret/ghcr created
```

Scaffold the necessary `SpinApp` Custom Resource (CR) using `spin k8s scaffold`:

```shell
# Scaffold the SpinApp manifest
spin k8s scaffold --from ghcr.io/$GH_USER/hello-spin:0.0.1 \
    --out spinapp.yaml
```

Before deploying the manifest with `kubectl`, update `spinapp.yaml` and link the `ghcr` secret you previously created using the `imagePullSecrets` property. Your `SpinApp` manifest should look like this:

```yaml
apiVersion: core.spinoperator.dev/v1
kind: SpinApp
metadata:
  name: hello-spin
spec:
  image: ghcr.io/$GH_USER/hello-spin:0.0.1
  imagePullSecrets:
    - name: ghcr
  replicas: 2
  executor: containerd-shim-spin
```

> `$GH_USER` should match the actual username provided while running through the previous sections of this article

Finally, you can deploy the app using `kubectl apply`: 

```shell
# Deploy the spinapp.yaml using kubectl
kubectl apply -f spinapp.yaml
spinapp.core.spinoperator.dev/hello-spin created
```
```
