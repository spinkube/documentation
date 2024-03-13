---
title: Installing with Helm
description: This guide walks you through the process of installing Spin Operator using [Helm](https://helm.sh).
date: 2024-02-16
weight: 100
categories: [Spin Operator]
tags: [Installing with Helm]
---

## Prerequisites

Please ensure that your system has all of the [prerequisites]({{< ref "prerequisites" >}}) installed before continuing.

For this guide in particular, you will need:

- [kubectl]({{< ref "prerequisites#kubectl" >}}) - the Kubernetes CLI
- [Helm]({{< ref "prerequisites#helm" >}}) - the package manager for Kubernetes

## Install Spin Operator With Helm

The following instructions are for installing Spin Operator using a Helm chart (using `helm install`).

### Prepare the Cluster

Before installing the chart, you'll need to ensure the following:

The [Custom Resource Definition (CRD)]({{< ref "glossary#custom-resource-definition-crd" >}}) resources are installed. This includes the SpinApp CRD representing Spin applications to be scheduled on the cluster.

```console
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.crds.yaml
```

A [RuntimeClass]({{< ref "glossary#runtime-class" >}}) resource class that
points to the `spin` handler called `wasmtime-spin-v2` will be created. If you
are deploying to a production cluster that only has a shim on a subset of nodes,
you'll need to modify the RuntimeClass with a `nodeSelector:`.

```console
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.runtime-class.yaml
```

The `containerd-spin-shim` [SpinAppExecutor]({{< ref "glossary#spin-app-executor-crd" >}}) custom resource is installed. This
tells Spin Operator to use the containerd shim executor to run Spin apps:

```console
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.shim-executor.yaml
```

## Chart prerequisites

- [cert-manager](https://github.com/cert-manager/cert-manager) to automatically provision and manage TLS certificates (used by spin-operator's admission webhook system). For detailed installation instructions see [the cert-manager documentation](https://cert-manager.io/docs/installation/).

```shell
# Install cert-manager CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.crds.yaml

# Add and update Jetstack repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.14.3
```

- [Kwasm Operator](https://github.com/kwasm/kwasm-operator) is required to install WebAssembly support on Kubernetes nodes. Note in the future this will be replaced by [runtime class manager](../../runtime-class-manager/_index.md). 

```shell
# Add Helm repository if not already done
helm repo add kwasm http://kwasm.sh/kwasm-operator/

# Install KWasm operator
helm install \
  kwasm-operator kwasm/kwasm-operator \
  --namespace kwasm \
  --create-namespace \
  --set kwasmOperator.installerImage=ghcr.io/spinkube/containerd-shim-spin/node-installer:v0.13.0

# Provision Nodes
kubectl annotate node --all kwasm.sh/kwasm-node=true
```

### Installing the Spin Operator Chart

The following installs the chart with the release name `spin-operator`:


```shell
# Install Spin Operator with Helm
helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --version 0.0.2 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator
```

### Upgrading the Chart

Note that you may also need to upgrade the spin-operator CRDs in tandem with upgrading the Helm release:

```shell
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.crds.yaml
```

To upgrade the `spin-operator` release, run the following:

```shell
# Upgrade Spin Operator using Helm
helm upgrade spin-operator \
  --namespace spin-operator \
  --version 0.0.2 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator
```

### Uninstalling the Chart

To delete the `spin-operator` release, run:

```shell
# Uninstall Spin Operator using Helm
helm delete spin-operator --namespace spin-operator
```

This will remove all Kubernetes resources associated with the chart and deletes the Helm release.

To completely uninstall all resources related to spin-operator, you may want to delete the corresponding CRD resources and, optionally, the RuntimeClass:

```console
kubectl delete -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.crds.yaml
kubectl delete -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.runtime-class.yaml
kubectl delete -f https://github.com/spinkube/spin-operator/releases/download/v0.0.2/spin-operator.shim-executor.yaml
```

<!-- TODO: list out configuration options? -->

