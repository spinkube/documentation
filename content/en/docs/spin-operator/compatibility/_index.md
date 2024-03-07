---
title: Compatibility
weight: 100
description: >
  Spin Operator Compatibility
categories: [Spin Operator]
tags: [Compatibility]
---

See the following list of compatible Kubernetes distributions and platforms for running the [Spin Operator](https://github.com/spinkube/spin-operator/):

 - [Amazon Elastic Kubernetes Service (EKS)](https://docs.aws.amazon.com/eks/)
 - [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service)
 - [Civo Kubernetes](https://www.civo.com/kubernetes)
 - [Digital Ocean Kubernetes (DOKS)](https://www.digitalocean.com/products/kubernetes)
 - [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine)
 - [k3d](https://k3d.io)
 - [Scaleway Kubernetes Kapsule](https://www.scaleway.com/en/kubernetes-kapsule/)

## `containerd` compatibility

The [Spin Operator](https://github.com/spinkube/spin-operator/) requires your Kubernetes cluster either having [`containerd 1.6.26+`](https://github.com/containerd/containerd/releases/tag/v1.6.26) or [`containerd 1.7.7+`](https://github.com/containerd/containerd/releases/tag/v1.7.7).