---
title: Running with Dapr
description: Running with Dapr
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## How to Configure Dapr With a Spin app on Kubernetes

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
  name: my-spinapp
  annotations:
    dapr.io/enabled: "true"
    dapr.io/app-id: "my-spinapp"
    dapr.io/app-port: "80"
    dapr.io/enable-api-logging: "true"
spec:
  image: "ghcr.io/thangchung/dapr-labs/product-api-spin:1.0.1"
  executor: containerd-shim-spin
  replicas: 1
EOF
```

Run the following command, in a different terminal window:

<!-- dapr_host = { default = "http://localhost" }
dapr_port = { default = "5003" }
dapr_app_name = { default = "myapp" }
dapr_pubsub_topic = { default = "orders" } -->

```bash
kubectl create -f ./config/samples/simple.yaml
```
