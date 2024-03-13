---
title: Running with Dapr
description: Running with Dapr
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## How to Configure Dapr With a Spin App on Kubernetes

Dapr is a portable, event-driven runtime that makes it easy for developers to build resilient
applications. It provides a set of building blocks for building applications, including state
management, pub/sub, and service invocation. Dapr applications can be written in any language and
run on any platform.

In this tutorial, we will deploy a Spin app on Kubernetes and configure it to use Dapr for Pub/Sub
communication.

## Prerequisites

Follow the [guide to run spin-operator](running-locally.md) to install the Spin Operator.

## Installing Dapr

In this post, we will use Dapr v1.13.0, which you should see as

```sh
dapr --version
CLI version: 1.12.0
Runtime version: n/a
```

Initialize Dapr on your cluster with the following command:

```sh
dapr init -k
⌛  Making the jump to hyperspace...
ℹ️  Note: To install Dapr using Helm, see here: https://docs.dapr.io/getting-started/install-dapr-kubernetes/#install-with-helm-advanced

ℹ️  Container images will be pulled from Docker Hub
✅  Deploying the Dapr control plane with latest version to your cluster...
✅  Deploying the Dapr dashboard with latest version to your cluster...
✅  Success! Dapr has been installed to namespace dapr-system. To verify, run `dapr status -k' in your terminal. To get started, go here: https://aka.ms/dapr-getting-started
```

Check the status of Dapr with the following command:

```sh
dapr status -k
  NAME                   NAMESPACE    HEALTHY  STATUS   REPLICAS  VERSION  AGE  CREATED
  dapr-placement-server  dapr-system  True     Running  1         1.12.5   15s  2024-03-05 14:21.49
  dapr-operator          dapr-system  True     Running  1         1.12.5   15s  2024-03-05 14:21.49
  dapr-sentry            dapr-system  True     Running  1         1.12.5   15s  2024-03-05 14:21.49
  dapr-dashboard         dapr-system  True     Running  1         0.14.0   14s  2024-03-05 14:21.50
  dapr-sidecar-injector  dapr-system  True     Running  1         1.12.5   15s  2024-03-05 14:21.49
```



## Running the Sample Application

Now we will run the sample application with Dapr Shared. To do this, we will need to create a
`SpinApp` resource that references the Dapr Shared instance.

```yaml
kubectl apply -f - <<EOF
apiVersion: core.spinoperator.dev/v1
kind: SpinApp
metadata:
  name: my-dapr-spin-app
  annotations:
    dapr.io/enabled: "true"
    dapr.io/app-id: "my-dapr-spin-app"
    dapr.io/app-port: "80"
    dapr.io/enable-api-logging: "true"
spec:
  image: "ghcr.io/thangchung/dapr-labs/product-api-spin:1.0.1"
  executor: containerd-shim-spin
  replicas: 1
EOF
```

Check that the application was deployed:

```sh
kubectl get spinapp my-dapr-spin-app
NAME               READY   DESIRED   EXECUTOR
my-dapr-spin-app   1       1         containerd-shim-spin
```

```sh
kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
my-dapr-spin-app-7664677875-nln2m   1/1     Running   0          82s
```

Connect to the application with the following command:

```sh
kubectl port-forward my-spinapp-7664677875-nln2m 8083:80
```

Now you can access the application at `http://localhost:8083`:

```sh
$ curl localhost:8083/v1-get-item-types
[{"image":"img/CAPPUCCINO.png","itemType":0,"name":"CAPPUCCINO","price":4.5},{"image":"img/COFFEE_BLACK.png","itemType":1,"name":"COFFEE_BLACK","price":3.0},{"image":"img/COFFEE_WITH_ROOM.png","itemType":2,"name":"COFFEE_WITH_ROOM","price":3.0},{"image":"img/ESPRESSO.png","itemType":3,"name":"ESPRESSO","price":3.5},{"image":"img/ESPRESSO_DOUBLE.png","itemType":4,"name":"ESPRESSO_DOUBLE","price":4.5},{"image":"img/LATTE.png","itemType":5,"name":"LATTE","price":4.5},{"image":"img/CAKEPOP.png","itemType":6,"name":"CAKEPOP","price":2.5},{"image":"img/CROISSANT.png","itemType":7,"name":"CROISSANT","price":3.25},{"image":"img/MUFFIN.png","itemType":8,"name":"MUFFIN","price":3.0},{"image":"img/CROISSANT_CHOCOLATE.png","itemType":9,"name":"CROISSANT_CHOCOLATE","price":3.5}]
```

## Dapr Shared

[Dapr Shared](https://github.com/dapr-sandbox/dapr-shared) allows you to create Dapr Applications using the `daprd` Sidecar as a Kubernetes `Daemonset` or `Deployment`. 

### Why Dapr Shared?

While sidecars are the default strategy, some use cases require other approaches. For example, you want to decouple the lifecycle of your workloads from the Dapr APIs. Dapr Shared offers a flexible approach to scenarios where the traditional sidecar model may not be ideal, such as with serverless functions that auto-scale. Allowing `daprd` to run as either a `DaemonSet` for reduced network latency or a `Deployment` for traditional scalability enables more efficient resource use and better lifecycle management of Dapr components across nodes. This adaptability makes Dapr Shared a valuable tool for developers leveraging Dapr in more dynamic, resource-conscious environments. 

### SpinKube and Dapr Shared

Combining the Spin framework and Dapr Shared allows developers to leverage Dapr's distributed system capabilities within a scalable and efficient WebAssembly-based architecture.

### Example
