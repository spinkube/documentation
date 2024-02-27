---
title: Contributing
weight: 100
description: >
  Contributing to Spin Plugin K8s
categories: [Spin Plugin K8s]
tags: [Contributing]
---

## Prerequisites

Please install Spin - see [prerequisites](../../spin-operator/prerequisites/_index.md#spin) section.

## Compiling Spin Plugin K8s from source

```bash
spin plugins update
spin plugins install pluginify --yes
git clone git@github.com:spinkube/spin-plugin-k8s.git
cd spin-plugin-k8s
make 
make install
```

## Contributing changes

Once your changes are made and tested locally please see the guidelines of [contributing to Spin](https://developer.fermyon.com/spin/v2/contributing-spin) for more details about committing and pushing your changes.