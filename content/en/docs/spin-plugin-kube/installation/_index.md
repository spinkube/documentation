---
title: Installation
description: Learn how to install the `kube` plugin for `spin`
weight: 1
categories: [guides]
tags: [plugins, kubernetes, spin]
---

The `kube` plugin for `spin` (The Spin CLI) provides first class experience for working with Spin apps in the context of Kubernetes.

## Prerequisites

Ensure the necessary [prerequisites]({{< ref "prerequisites" >}}) are installed.

For this tutorial in particular, you will need

- [spin]({{< ref "prerequisites#spin-cli" >}}) - the Spin CLI

## Install the plugin

Before you install the `kube` plugin for `spin`, you should fetch the list of latest Spin plugins from the spin-plugins repository:

```sh
# Update the list of latest Spin plugins
spin plugins update
Plugin information updated successfully
```

Go ahead and install the `kube` using `spin plugin install`:

```sh
# Install the latest kube plugin
spin plugins install kube
```

At this point you should see the `kube` plugin when querying the list of installed Spin plugins:

```sh
# List all installed Spin plugins
spin plugins list --installed

cloud 0.7.0 [installed]
cloud-gpu 0.1.0 [installed]
kube 0.1.0 [installed]
pluginify 0.6.0 [installed]
```

### Canary release

For the canary release:

```sh
spin plugins install --url https://github.com/spinkube/spin-plugin-kube/releases/download/canary/kube.json
```

The canary release may not be stable, with some features still in progress.

### Compiling from source

As an alternative to the plugin manager, you can download and manually install the plugin. Manual
installation is commonly used to test in-flight changes. For a user, installing the plugin using
Spin's plugin manager is better.

Please refer to the [contributing guide](../contributing/_index.md) for instructions on how to
compile the plugin from source.
