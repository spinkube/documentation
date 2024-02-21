---
title: containerd-shim-spin
description: The Containerd Shim Spin is a project that integrates WebAssembly (Wasm) and WASI workloads into Kubernetes.
categories: []
tags: []
weight: 80
---

The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin), or "contained-shim-spin," provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment. 

The containerd-shim-spin is specifically designed to work with the [Spin](https://www.fermyon.com/spin) framework (a developer tool for building and running serverless Wasm applications). The shim ensures that Wasm workloads can be managed effectively within a Kubernetes environment, leveraging containerd's capabilities.

In a Kubernetes cluster, specific nodes can be bootstrapped with Wasm runtimes and labeled accordingly to facilitate the scheduling of Wasm workloads. RuntimeClasses in Kubernetes are used to schedule Pods to specific nodes and target specific runtimes. By defining a RuntimeClass with the appropriate nodeSelector and handler, Kubernetes can direct Wasm workloads to nodes equipped with the necessary Wasm runtimes and ensure they are executed with the correct runtime handler.

Overall, the Containerd Shim Spin represents a significant advancement in integrating Wasm workloads into Kubernetes clusters, enhancing the versatility and capabilities of container orchestration.