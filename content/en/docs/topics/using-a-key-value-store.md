---
title: Using a key value store
description: Connect your Spin App to a key value store
date: 2024-07-29
categories: [Spin Operator]
tags: [Tutorials]
weight: 14
---

Spin applications can utilize a [standardized API for persisting data in a key value store](https://developer.fermyon.com/spin/v2/kv-store-api-guide). The default key value store in Spin is an SQLite database, which is great for quickly utilizing non-relational local storage without any infrastructure set-up. However, this solution may not be preferable for an app running in the context of SpinKube, where apps are often scaled beyond just one replica.

Thankfully, Spin supports configuring an application with an [external key value provider](https://developer.fermyon.com/spin/v2/dynamic-configuration#key-value-store-runtime-configuration). External providers include [Redis](https://redis.io/) or [Valkey](https://valkey.io/) and [Azure Cosmos DB](https://azure.microsoft.com/en-us/products/cosmos-db).

## Prerequisites

To follow along with this tutorial, you'll need:

- A Kubernetes cluster running SpinKube. See the [Installation]({{< relref "install" >}}) guides for more information.
- The [kubectl CLI](https://kubernetes.io/docs/tasks/tools/#kubectl)
- The [spin CLI](https://developer.fermyon.com/spin/v2/install )

## Build and publish the Spin application

For this tutorial, we'll use a [Spin key/value application](https://github.com/fermyon/spin-go-sdk/tree/main/examples/key-value) written with the Go SDK. The application serves a CRUD (Create, Read, Update, Delete) API for managing key/value pairs.

First, clone the repository locally and navigate to the `examples/key-value` directory:

```bash
git clone git@github.com:fermyon/spin-go-sdk.git
cd examples/key-value
```

Now, build and push the application to a registry you have access to. Here we'll use [ttl.sh](https://ttl.sh):

```bash
export IMAGE_NAME=ttl.sh/$(uuidgen):1h
spin build
spin registry push ${IMAGE_NAME}
```

## Configure an external key value provider

Since we have access to a Kubernetes cluster already running SpinKube, we'll choose [Valkey](https://valkey.io/) for our key value provider and install this provider via Bitnami's [Valkey Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/valkey). Valkey is swappable for Redis in Spin, though note we do need to supply a URL using the `redis://` protocol rather than `valkey://`.

```bash
helm install valkey --namespace valkey --create-namespace oci://registry-1.docker.io/bitnamicharts/valkey
```

As mentioned in the notes shown after successful installation, be sure to capture the valkey password for use later:

```bash
export VALKEY_PASSWORD=$(kubectl get secret --namespace valkey valkey -o jsonpath="{.data.valkey-password}" | base64 -d)
```

## Create a Kubernetes Secret for the Valkey URL

The runtime configuration will require the Valkey URL so that it can connect to this provider. As this URL contains the sensitive password string, we will create it as a Secret resource in Kubernetes:

```bash
kubectl create secret generic kv-secret --from-literal=valkey-url="redis://:${VALKEY_PASSWORD}@valkey-master.valkey.svc.cluster.local:6379"
```

## Prepare the SpinApp manifest

You're now ready to assemble the SpinApp custom resource manifest for this application.

- All of the key value config is set under `spec.runtimeConfig.keyValueStores`. See the [keyValueStores reference guide]({{< ref "docs/reference/spin-app#spinappspecruntimeconfigkeyvaluestoresindex" >}}) for more details.
- Here we configure the `default` store to use the `redis` provider type and under `options` supply the Valkey URL (via its Kubernetes secret)

Plug the `$IMAGE_NAME` and `$DB_URL` values into the manifest below and save as `spinapp.yaml`:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: kv-app
spec:
  image: "$IMAGE_NAME"
  replicas: 1
  executor: containerd-shim-spin
  runtimeConfig:
    keyValueStores:
      - name: "default"
        type: "redis"
        options:
          - name: "url"
            valueFrom:
              secretKeyRef:
                name: "kv-secret"
                key: "valkey-url"
```

## Create the SpinApp

Apply the resource manifest to your Kubernetes cluster:

```bash
kubectl apply -f spinapp.yaml
```

The Spin Operator will handle the creation of the underlying Kubernetes resources on your behalf.

## Test the application

Now you are ready to test the application and verify connectivity and key value storage to the configured provider.

Configure port forwarding from your local machine to the corresponding Kubernetes `Service`:

```bash
kubectl port-forward services/kv-app 8080:80

Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

When port forwarding is established, you can send HTTP requests to the application from within an additional terminal session. Here are a few examples to get you started.

Create a `test` key with value `ok!`:

```bash
$ curl -i -X POST -d "ok!" localhost:8080/test
HTTP/1.1 200 OK
content-length: 0
date: Mon, 29 Jul 2024 19:58:14 GMT
```

Get the value for the `test` key:

```bash
$ curl -i -X GET localhost:8080/test
HTTP/1.1 200 OK
content-length: 3
date: Mon, 29 Jul 2024 19:58:39 GMT

ok!
```

Delete the value for the `test` key:

```bash
$ curl -i -X DELETE localhost:8080/test
HTTP/1.1 200 OK
content-length: 0
date: Mon, 29 Jul 2024 19:59:18 GMT
```

Attempt to get the value for the `test` key:

```bash
$ curl -i -X GET localhost:8080/test
HTTP/1.1 500 Internal Server Error
content-type: text/plain; charset=utf-8
x-content-type-options: nosniff
content-length: 12
date: Mon, 29 Jul 2024 19:59:44 GMT

no such key
```