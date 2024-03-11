---
title: Running locally
description: Learn how to run Spin Operator on your local machine
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## Prerequisites

Please ensure that your system has all the [prerequisites]({{< ref "prerequisites" >}}) installed
before continuing.

## Fetch Spin Operator (Source Code)

Clone the Spin Operator repository:

```console
git clone https://github.com/spinkube/spin-operator.git
```

Change into the Spin Operator directory:

```console
cd spin-operator
```

## Setting Up Kubernetes Cluster

Run the following command to create a Kubernetes k3d cluster that has [the
containerd-wasm-shims](https://github.com/deislabs/containerd-wasm-shims) pre-requisites installed:

```console
k3d cluster create wasm-cluster --image ghcr.io/deislabs/containerd-wasm-shims/examples/k3d:v0.11.0 -p "8081:80@loadbalancer" --agents 2
```

Run the following command to install the Custom Resource Definitions (CRDs) into the cluster:

```console
make install
```

## Running spin-operator

Run the following command to run the Spin Operator locally:

```console
make run
```

In a fresh terminal, run the following command to create a Runtime Class named `wamtime-spin-v2`:

```console
kubectl apply -f - <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: wasmtime-spin-v2
handler: spin
EOF
```

A SpinAppExecutor is a custom resource that defines how an application should be executed. The
SpinAppExecutor provides ways for the user to configure how the application should run, like which
runtime class to use.

SpinAppExecutors can be defined at the namespace level, allowing multiple SpinAppExecutors to refer
to different runtime classes in the same namespace. This means that a SpinAppExecutor must exist in
every namespace where a SpinApp is to be executed.

Run the following command to create a SpinAppExecutor using the same runtime class as the one
created above:

```console
kubectl apply -f - <<EOF
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinAppExecutor
metadata:
  name: containerd-shim-spin
spec:
  createDeployment: true
  deploymentConfig:
    runtimeClassName: wasmtime-spin-v2
EOF
```

## Running the Sample Application

Run the following command, in a different terminal window:

```console
kubectl apply -f ./config/samples/simple.yaml
```

Run the following command to obtain the name of the pod you have running:

```console
kubectl get pods
```

The above command will return information similar to the following:

```console
NAME                              READY   STATUS    RESTARTS   AGE
simple-spinapp-5b8d8d69b4-snscs   1/1     Running   0          3m40s

```

Using the `NAME` from above, run the following `kubectl` command to listen on port 8083 locally and
forward to port 80 in the pod:

```console
kubectl port-forward simple-spinapp-5b8d8d69b4-snscs 8083:80
```

The above command will return the following forwarding mappings:

```console
Forwarding from 127.0.0.1:8083 -> 80
Forwarding from [::1]:8083 -> 80
```

In a fresh terminal, run the following command:

```console
curl localhost:8083/hello
```

The above command will return the following message:

```console
Hello world from Spin!
```
