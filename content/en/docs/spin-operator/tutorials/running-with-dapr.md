---
title: Running with Dapr
description: Running with Dapr
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## How to Configure Dapr Shared With a SpinApp

In this tutorial we will configure Dapr Shared with a SpinApp.

## Dapr Shared

[Why Dapr Shared](https://github.com/dapr-sandbox/dapr-shared?tab=readme-ov-file#why-dapr-shared)?

Dapr Shared is a framework designed to share Dapr sidecars across multiple applications. This approach optimizes resource utilization by allowing applications to share a common set of Dapr sidecars, reducing the overhead of deploying individual sidecars for each application. Dapr Shared extends the Dapr sidecar model with two new deployment strategies: the flexibility to create Dapr Applications using the `daprd` Sidecar either as a Kubernetes `DaemonSet` or a `Deployment`.

Opting for `daprd` as a Kubernetes `DaemonSet` ensures that the `daprd` container operates on every Kubernetes Node. This setup significantly minimizes the network distance between applications and Dapr, enhancing performance. 

Alternatively, deploying Dapr Shared as a Kubernetes `Deployment` allows the Kubernetes scheduler to determine the specific node where the Dapr Shared instance will operate. This method offers a balanced distribution of resources and workload management across the Kubernetes environment.

## Prerequisites

Please see the [Go](./prerequisites.md#go), [Docker](./prerequisites.md#docker), [Kubectl](./prerequisites.md#kubectl), [k3d](./prerequisites.md#k3d) and [Helm](./prerequisites.md#helm) sections in the [Prerequisites](./prerequisites.md) page and fulfill those prerequisite requirements before continuing.

## Fetch Spin Operator (Source Code)

Clone the Spin Operator repository:

```bash
git clone https://github.com/spinkube/spin-operator.git
```

Change into the Spin Operator directory:

```bash
cd spin-operator
```

## Setting Up Kubernetes Cluster

Run the following command to create a Kubernetes k3d cluster that has [the containerd-wasm-shims](https://github.com/deislabs/containerd-wasm-shims) pre-requisites installed:

```bash
k3d cluster create wasm-cluster --image ghcr.io/deislabs/containerd-wasm-shims/examples/k3d:v0.10.0 -p "8081:80@loadbalancer" --agents 2
```

Run the following command to create the Runtime Class:

```bash
kubectl apply -f - <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: wasmtime-spin-v2
handler: spin
EOF
```

## Installation With Make

Run the following command to install the Custom Resource Definition (CRD) into the cluster:

```bash
make install
```

## Running the Sample Application

Run the following command to run the Spin Operator locally:

```bash
make run
``` 

Run the following command, in a different terminal window:

```bash
kubectl apply -f ./config/samples/simple.yaml
```

## Dapr Shared Instance

For each application service that needs to talk to the Dapr APIs we need to deploy a new Dapr Shared instance. Each instance will have a one-to-one relationship with Dapr Application IDs.

The `shared.appId` is a configuration element used in Dapr that specifies the unique identifier for a Dapr application. The `shared.remoteURL` and `shared.remotePort` are the reachable URL and Port. Creating a Dapr Shared instance can be done via the `helm` command, as per the example below:

```bash
helm install my-shared-instance \
  oci://registry-1.docker.io/daprio/dapr-shared-chart \
  --set shared.appId=<DAPR_APP_ID> \
  --set shared.remoteURL=<REMOTE_URL> \
  --set shared.remotePort=<REMOTE_PORT>
```

For example:

```bash
helm install my-shared-instance \
oci://registry-1.docker.io/daprio/dapr-shared-chart \
--set shared.appId=simple-spinapp \
--set shared.remoteURL=simple-spinapp \
--set shared.remotePort=8083
```

The above helm command will return something similar to the following:

```bash
Pulled: registry-1.docker.io/daprio/dapr-shared-chart:0.0.12
Digest: sha256:f63a5936f43294aa1aacb8695c06d43efd5f1672a336a954b4a15990bcfb8112
NAME: my-shared-instance
LAST DEPLOYED: Fri Jan 19 15:59:33 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

> Note: You can [Customize Dapr Shared using Helm values](https://github.com/dapr-sandbox/dapr-shared?tab=readme-ov-file#customize-dapr-shared).
