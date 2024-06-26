---
title: containerd-shim-spin
description: The Containerd Shim Spin is a project that enables running Spin applications on Kubernetes.
categories: [Containerd Shim Spin]
tags: [containerd-shim-spin]
weight: 60
---

The [`containerd-shim-spin`](https://github.com/spinkube/containerd-shim-spin) is a [containerd shim](https://github.com/containerd/containerd/blob/main/core/runtime/v2/README.md#runtime-shim) implementation for [Spin](https://developer.fermyon.com/spin), which enables running Spin workloads on Kubernetes via [runwasi](https://github.com/deislabs/runwasi). This means that by installing this shim onto Kubernetes nodes, we can add a [runtime class](https://kubernetes.io/docs/concepts/containers/runtime-class/) to Kubernetes and schedule Spin workloads on those nodes. Your Spin apps can act just like container workloads!

The `containerd-shim-spin` is specifically designed to execute applications built with [Spin](https://www.fermyon.com/spin) (a developer tool for building and running serverless Wasm applications). The shim ensures that Wasm workloads can be managed effectively within a Kubernetes environment, leveraging containerd's capabilities.

In a Kubernetes cluster, specific nodes can be bootstrapped with Wasm runtimes and labeled accordingly to facilitate the scheduling of Wasm workloads. `RuntimeClasses` in Kubernetes are used to schedule Pods to specific nodes and target specific runtimes. By defining a `RuntimeClass` with the appropriate `NodeSelector` and handler, Kubernetes can direct Wasm workloads to nodes equipped with the necessary Wasm runtimes and ensure they are executed with the correct runtime handler.

Overall, the Containerd Shim Spin represents a significant advancement in integrating Wasm workloads into Kubernetes clusters, enhancing the versatility and capabilities of container orchestration.

## Shim and Spin Version Map


Below is a table of the shims and the the most recent versions of the shims that are supported by this project.

| **shim version** | v0.12.0                                                       | v0.13.0                                                       | v0.14.0                                                       | v0.14.1                                                       | v0.15.0                                                       |
| ---------------- | ------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------- |
| **spin**         | [v2.2.0](https://github.com/fermyon/spin/releases/tag/v2.2.0) | [v2.3.1](https://github.com/fermyon/spin/releases/tag/v2.3.1) | [v2.4.2](https://github.com/fermyon/spin/releases/tag/v2.4.2) | [v2.4.3](https://github.com/fermyon/spin/releases/tag/v2.4.3) | [v2.6.0](https://github.com/fermyon/spin/releases/tag/v2.6.0) |

## Installing the `containerd-shim-spin` on Kubernetes Nodes

In order to run Spin applications on your cluster, you must complete the following three steps:

1. Install the shim on each Node that should support Spin apps
2. Update the containerd configuration to recognize the shim
3. Apply the Kubernetes `RuntimeClass` for the shim

Repeating steps 1 and 2 for each node on a cluster can be a timely and manual process. For this reason, SpinKube provides a [`runtime-class-manager`](../runtime-class-manager/) (previously the `kwasm` operator) that enables you to skip over step 1 and 2. See the [installation guide](../spin-operator/installation/installing-with-helm.md) for more information on installing with Helm.

To execute the installation step-by-step, do the following:

1. Install the shim on each Node that should support Spin apps

    Install a [release of the shim](https://github.com/spinkube/containerd-shim-spin/releases) somewhere on the path of your Kubernetes worker nodes. For example, copy `containerd-shim-spin-v2` to `/bin`. Shims are additive, so once the `containerd-shim-spin` is installed on a Node, it can support Spin WebAssembly apps alongside traditional containerized deployments. 

1. Add the following to the containerd config.toml that maps the runtime type to the shim binary from step 1:

    ```toml
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.spin]
    runtime_type = "io.containerd.spin.v2"
    ```

    The [Node Installer script](https://github.com/spinkube/containerd-shim-spin/blob/main/node-installer/script/installer.sh) that is used by the `runtime-class-manager` does this for you and is a good reference to understand the common paths to the containerd configuration file for popular Kubernetes distributions.

1. Apply a runtime class that contains a handler that matches the "spin" config runtime name from step 2.

    This ensures that the image is executed with the correct runtime, namely the `containerd-shim-spin`.

    > Note: You likely want to customize the Runtime Class with a [`nodeSelector`](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) to ensure Pods are only scheduled to Nodes where the shim has been installed.

    ```yaml
    apiVersion: node.k8s.io/v1
    kind: RuntimeClass
    metadata:
    name: wasmtime-spin-v2
    handler: spin

    ```

1. Deploy a Spin app to your cluster with the specified `RuntimeClass` name matching the "wasmtime-spin-v2" runtime class from step 3. The [Spin Operator](../spin-operator/_index.md) does this for you, translating `SpinApp` custom resources into Kubernetes deployments:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: wasm-spin
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: wasm-spin
    template:
        metadata:
        labels:
            app: wasm-spin
        spec:
        runtimeClassName: wasmtime-spin-v2
        containers:
            - name: spin-hello
            image: ghcr.io/spinkube/containerd-shim-spin/examples/spin-rust-hello:v0.13.0
            command: ["/"]
    ```
