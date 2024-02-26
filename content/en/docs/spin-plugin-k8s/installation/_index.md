---
title: Installation
description: Learn how to install the `k8s` plugin for `spin` 
weight: 50
categories: [Spin Plugin k8s]
tags: [Installation]
---

The `k8s` plugin for `spin` (The Spin CLI) provides first class experience for working with Spin Apps in the context of Kubernetes.

## Prerequisites

Ensure the necessary [prerequisites]({{< ref "prerequisites" >}}) are installed.

For this tutorial in particular, you need

- [spin]({{< ref "prerequisites#spin-cli" >}}) - the Spin CLI
- [Go]({{< ref "prerequisites#go" >}})* - Go programming language

> Prerequisites marked with * are only required if you want to build the `k8s` plugin from source


## Install Spin Plugin k8s

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

# Spin k8s plugin

A [Spin plugin](https://github.com/fermyon/spin-plugins) for interacting with Kubernetes.

## Install

Install the stable release:

```sh
spin plugins update
spin plugins install k8s
```

### Canary release

For the canary release:

```sh
spin plugins install --url https://github.com/spinkube/spin-plugin-k8s/releases/download/canary/k8s.json
```

The canary release may not be stable, with some features still in progress.

### Compiling from source

As an alternative to the plugin manager, you can download and manually install the plugin. Manual installation is
commonly used to test in-flight changes. For a user, it's better to install the plugin using Spin's plugin manager.

Ensure the `pluginify` plugin is installed:

```sh
spin plugins update
spin plugins install pluginify --yes
```

Fetch the plugin:

```sh
git clone git@github.com:spinkube/spin-plugin-k8s.git
cd spin-plugin-k8s
```

Compile and install the plugin:

```sh
make
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
