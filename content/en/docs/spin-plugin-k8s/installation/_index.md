---
title: Installation
description: Learn how to install the `k8s` plugin for `spin` 
weight: 50
categories: [Spin plugin k8s]
tags: [Installation]
---

The `k8s` plugin for `spin` (The Spin CLI) provides first class experience for working with Spin Apps in the context of Kubernetes.

## Prerequisites

Ensure the necessary [prerequisites]({{< ref "prerequisites" >}}) are installed.

For this tutorial in particular, you need

- [spin]({{< ref "prerequisites#spin-cli" >}}) - the Spin CLI
- [Go]({{< ref "prerequisites#go" >}})* - Go programming language

> Prerequisites marked with * are only required if you want to build the `k8s` plugin from source


## Install spin plugin k8s

Before you install the `k8s` plugin for `spin`, you should fetch the list of latest Spin plugins from the spin-plugins repository:

```shell
# Update the list of latest Spin plugins
spin plugins update
Plugin information updated successfully
```

Go ahead and install the `k8s` using `spin plugin install`: 

```shell
# Install the latest k8s plugin
spin plugins install k8s
```

At this point you should see the `k8s` plugin when querying the list of installed Spin plugins:

```shell
# List all installed Spin plugins
spin plugins list --installed

cloud 0.7.0 [installed]
cloud-gpu 0.1.0 [installed]
k8s 0.1.0 [installed]
pluginify 0.6.0 [installed]
```

## Installing spin plugin k8s from source

Alternatively, you can install the `k8s` plugin for spin from source code by following the steps described here. 

First, clone the [spin-plugin-k8s](https://github.com/spinkube/spin-plugin-k8s) repository:

```shell
git clone git@github.com:spinkube/spin-plugin-k8s.git
Cloning into 'spin-plugin-k8s'...
remote: Enumerating objects: 70, done.
remote: Counting objects: 100% (70/70), done.
remote: Compressing objects: 100% (54/54), done.
remote: Total 70 (delta 18), reused 61 (delta 15), pack-reused 0
Receiving objects: 100% (70/70), 38.68 KiB | 435.00 KiB/s, done.
Resolving deltas: 100% (18/18), done.
```

Move into the `spin-plugin-k8s` folder (`cd spin-plugin-k8s`).

Next, you compile the plugin from source code:

```shell
# Compile spin-plugin-k8s
make build
```

Finally, you can install the plugin: 

```shell
# Install spin-plugin-k8s
make install
```
At this point you should see the `k8s` plugin when querying the list of installed Spin plugins:

```shell
# List all installed Spin plugins
spin plugins list --installed

cloud 0.7.0 [installed]
cloud-gpu 0.1.0 [installed]
k8s 0.1.0 [installed]
pluginify 0.6.0 [installed]
```
