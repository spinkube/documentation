---
title: Spintainer Executor
description: An overview of what the Spintainer Executor does and how it can be used.
categories: [SpinKube]
tags: []
---

# The Spintainer Executor

The Spintainer (a play on the words Spin and container) executor is a [SpinAppExecutor](../../reference/spin-app-executor) that runs Spin applications directly in a container rather than via the [shim](../../topics/architecture#containerd-shim-spin). This is useful for a number of reasons:

- Provides the flexibility to:
  - Use any Spin version you want.
  - Use any custom triggers or plugins you want.
- Allows you to use SpinKube even if you don't have the cluster permissions to install the shim.

> Note: We recommend using the shim for most use cases. The spintainer executor is best saved as a workaround.

## How to create a spintainer executor

The following is some sample configuration for a spintainer executor:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinAppExecutor
metadata:
  name: spintainer
spec:
  createDeployment: true
  deploymentConfig:
    installDefaultCACerts: true
    spinImage: ghcr.io/fermyon/spin:v2.7.0
```

Save this into a file named `spintainer-executor.yaml` and then apply it to the cluster.

```bash
kubectl apply -f spintainer-executor.yaml
```

## How to use a spintainer executor

To use the spintainer executor you must reference it as the executor of your `SpinApp`.

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: simple-spinapp
spec:
  image: "ghcr.io/spinkube/containerd-shim-spin/examples/spin-rust-hello:v0.13.0"
  replicas: 1
  executor: spintainer
```

## How the spintainer executor works

The spintainer executor executes your Spin application in a container created from the image specified by `.spec.deploymentConfig.spinImage`. The container image must have a Spin binary be the [entrypoint](https://docs.docker.com/reference/dockerfile/#entrypoint) of the container. It will be started with the following args.

```
up --listen {spin-operator-defined-port} -f {spin-operator-defined-image} --runtime-config-file {spin-operator-defined-config-file}
```

For ease of use you can use the images published by the Spin project [here](https://github.com/fermyon/spin/pkgs/container/spin). Alternatively you can craft images for your own unique need.
