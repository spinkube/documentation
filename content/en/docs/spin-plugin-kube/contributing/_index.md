---
title: Contributing
weight: 5
description: >
  Contributing to the Spin plugin for Kubernetes
categories: [contributing]
tags: [contributing, plugins, kubernetes, spin, go]
---

## Prerequisites

To compile the plugin from source, you will need

- [spin]({{< ref "prerequisites#spin-cli" >}}) - the Spin CLI
- [Go]({{< ref "prerequisites#go" >}})* - Go programming language
- [make]({{< ref "prerequisites#make" >}})* - GNU Make
- [The `pluginify` plugin]({{< ref "prerequisites#spin-pluginify" >}})* - A plugin for Spin that helps with plugin development

## Compiling the plugin from source

Fetch the source code from GitHub:

```sh
git clone git@github.com:spinkube/spin-plugin-kube.git
cd spin-plugin-kube
```

Compile and install the plugin:

```sh
make
make install
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

## Contributing changes

Once your changes are made and tested locally please see the guidelines of [contributing to Spin](https://developer.fermyon.com/spin/v2/contributing-spin) for more details about committing and pushing your changes.
