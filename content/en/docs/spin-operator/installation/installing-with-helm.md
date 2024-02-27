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

<!-- NOTE: remove this prerequisite when the runtime-class and CRDs can be applied from their release artifacts, i.e. when repo and release are public -->

Also, ensure you have cloned this repository and have navigated to the root of the project:

```console
git clone git@github.com:spinkube/spin-operator.git
cd spin-operator
```

## Install Spin Operator With Helm

The following instructions are for installing Spin Operator using a Helm chart (using `helm install`).

### Prepare the Cluster

Before installing the chart, you'll need to ensure the following:

The [Custom Resource Definition (CRD)]({{< ref "glossary#custom-resource-definition-crd" >}}) resources are installed. This includes the `SpinApp` CRD representing Spin applications to be scheduled on the cluster.

<!-- TODO: replace with e.g. 'kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0-rc.1/spin-operator.crds.yaml' -->

```console
make install
```

A [RuntimeClass]({{< ref "glossary#runtime-class" >}}) resource class that
points to the `spin` handler called `wasmtime-spin-v2` will be created. If you
are deploying to a production cluster that only has a shim on a subset of nodes,
you'll need to modify the RuntimeClass with a `nodeSelector:`.

<!-- TODO: replace with e.g. 'kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0-rc.1/spin-operator.runtime-class.yaml' -->

```console
kubectl apply -f spin-runtime-class.yaml
```

## Chart prerequisites

- [Cert Manager](https://github.com/cert-manager/cert-manager) to automatically provision and manage TLS certificates (used by spin-operator's admission webhook system). For detailed installation instructions see [the cert-manager documentation](https://cert-manager.io/docs/installation/).

```console
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
```

## Chart dependencies

The spin-operator chart currently includes the following sub-charts:

- [Kwasm Operator](https://github.com/kwasm/kwasm-operator) to install WebAssembly support on Kubernetes nodes

### Installing the Chart

The following installs the chart with the release name `spin-operator`:

<!-- TODO: remove '--devel' flag once we have our first non-prerelease chart available, e.g. when v0.1.0 of this project is released and public -->

```shell
# Install Spin Operator with Helm
helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --devel \
  --wait \
  oci://ghcr.io/spinkube/spin-operator
```

### Upgrading the Chart

Note that you may also need to upgrade the spin-operator CRDs in tandem with upgrading the Helm release:

<!-- TODO: replace with e.g. 'kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0-rc.1/spin-operator.crds.yaml' -->

```
make install
```

To upgrade the `spin-operator` release, run the following:

<!-- TODO: remove '--devel' flag once we have our first non-prerelease chart available, e.g. when v0.1.0 of this project is released and public -->

```shell
# Upgrade Spin Operator using Helm
helm upgrade spin-operator \
  --namespace spin-operator \
  --devel \
  --wait \
  oci://ghcr.io/spinkube/spin-operator
```

### Uninstalling the Chart

To delete the `spin-operator` release, run:

```shell
# Uninstall Spin Operator using Helm
helm delete spin-operator --namespace spin-operator
```

This will remove all Kubernetes resources associated with the chart and deletes the Helm release.

To completely uninstall all resources related to spin-operator, you may want to delete the corresponding CRD resources and, optionally, the RuntimeClass:

<!-- TODO: replace with:
```console
kubectl delete -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0-rc.1/spin-operator.crds.yaml

kubectl delete -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0-rc.1/spin-operator.runtime-class.yaml
```
-->

```console
make uninstall
kubectl delete -f spin-runtime-class.yaml
```

<!-- TODO: list out configuration options? -->

