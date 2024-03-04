---
title: Spin Operator
description: Spin Operator
categories: [Spin Operator]
tags: [Spin Operator]
weight: 100
---

### What is Spin Operator

Simply put, [Spin Operator](https://github.com/spinkube/spin-operator/) is a [Kubernetes operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) which empowers platform engineers to deploy [Spin applications](https://developer.fermyon.com/spin) as custom resources to their Kubernetes clusters. For platform engineers looking to improve their cluster utilization without compromising on performance all while maintaining workload portability, Spin Operator provides an elegant solution. 

### Why Spin Operator? 

By supporting SpinApps, Spin Operator provides application developers and platform engineers with the best of both worlds. For developers, this means being able to easily build portable serverless functions that leverage the power and performance of Wasm via the Spin developer tool. For platform engineers, this looks like being able to use idomatic Kubernetes primatives (secrets, atuoscaling, metrics, etc.) and tooling to manage these workloads at scale in a production environment improving their overall operational efficiency. 

>> TODO - once we have examples, this would be a good section to link out to them 

### How Does Spin Operator Work? 

Built with the [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) framework, Spin Operator is a Kubernetes operator. Kubernetes operators are used to extend Kubernetes automation to new objects, defined as custom resources, without modifying the Kubernetes API. The Spin Operator is composed of two main components: A) A controller that defines and manages B) "SpinApps" Custom Resource Definition (CRD).  

>> TODO - architecture diagram