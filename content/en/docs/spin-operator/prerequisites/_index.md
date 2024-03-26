---
title: Prerequisites
description: Prerequisites
weight: 1
categories: [Spin Operator]
tags: [Prerequisites]
---

The following prerequisites are required.

## Go

If building the Spin Operator from source or contributing to the development of Spin Operator then you will require [Go](https://go.dev/doc/install) version v1.22.0+ to be installed on your machine. Otherwise, please ignore this section, and move to the next prerequisite.

### TinyGo

Please also install the latest version of [TinyGo](https://tinygo.org/getting-started/install/)

## Managing Containers and Kubernetes Locally

If you’d like to run Spin Operator locally, you have the option of using Rancher Desktop or Docker Desktop, as the interface for managing containers and Kubernetes clusters directly from your workstation.

### Rancher Desktop

If you choose [Rancher Desktop](https://rancherdesktop.io/) it is recommended to install version 1.13.0 or higher. Additionally, you will need to [configure it to support WebAssembly applications]({{< ref "integrating-with-rancher-desktop#rancher-desktop-preferences" >}}).

### Docker Desktop

If you choose [Docker Desktop](https://docs.docker.com/get-docker/) it is recommended to install version 17.03 or higher. Additionally, you will need to [configure it to support WebAssembly applications]({{< ref "integrating-with-docker-desktop#docker-desktop-preferences" >}}).


## Kubectl

If you'd like to manage your Spin applications with `kubectl`, then Spin Operator requires that you have [kubectl](https://kubernetes.io/docs/tasks/tools/) version v1.27.0+ installed.

## K3d

If running/deploying your Spin application involves the use of k3d, then the Spin Operator requires that you have [k3d](https://k3d.io/v5.6.0/?h=installation#installation) installed and that you have access to a Kubernetes v1.27.0 cluster.

## containerd

If running/deploying your Spin application involves the use of **k3s** or a baremetal host, then the Spin Operator requires that you have [containerD](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) installed.

## Helm

If running/deploying your Spin application involves the use of Helm, then the Spin Operator requires that you have [Helm](https://helm.sh/docs/intro/install/#helm) installed on your system.

## Spin

Please install the latest version ([2.3.1 or newer](https://developer.fermyon.com/spin/v2/upgrade)) of [Spin](https://developer.fermyon.com/spin/v2/install) on your local machine for creating Spin Apps.

## Bombardier

Installing [Bombardier](https://pkg.go.dev/github.com/codesenberg/bombardier) is **not** required to use Spin Operator. Bombardier is used in tutorials like [Scaling Spin App With Horizontal Pod Autoscaling]({{< ref "scaling-with-hpa" >}}) to generate load to test autoscaling.

## Azure CLI

Installing [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) is **not** required to use Spin Operator. Azure CLI is used to provision Azure Kubernetes Service (AKS) and necessary Azure resources as part of the [Deploy Spin Operator on Azure Kubernetes Service]({{< ref "deploy-on-azure-kubernetes-service" >}}) tutorial.
