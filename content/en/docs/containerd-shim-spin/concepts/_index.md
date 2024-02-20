---
title: Concepts
weight: 60
description: >
  The Containerd Shim Spin is a project that integrates WebAssembly (Wasm) and WASI workloads into Kubernetes, allowing these workloads to be managed and run as regular container workloads through the implementation of specialized containerd shims.
categories: []
tags: []
---

The Containerd Shim Spin, or "contained-shim-spin," is part of a broader initiative to integrate Wasm workloads into Kubernetes using containerd. This project is spearheaded by the Containerd Wasm Shims project, which aims to create containerd shim implementations capable of running Wasm/WASI workloads using runwasi as a library. By installing these shims onto Kubernetes nodes, a runtime class can be added to Kubernetes, enabling the scheduling of Wasm workloads on those nodes. This integration allows Wasm pods and deployments to operate similarly to traditional container workloads.

The containerd-shim-spin is specifically designed to work with the [Spin](https://www.fermyon.com/spin) framework (a developer tool for building and running serverless Wasm applications). The shim ensures that Wasm workloads can be managed effectively within a Kubernetes environment, leveraging containerd's capabilities.

In a Kubernetes cluster, specific nodes can be bootstrapped with Wasm runtimes and labeled accordingly to facilitate the scheduling of Wasm workloads. RuntimeClasses in Kubernetes are used to schedule Pods to specific nodes and target specific runtimes. By defining a RuntimeClass with the appropriate nodeSelector and handler, Kubernetes can direct Wasm workloads to nodes equipped with the necessary Wasm runtimes and ensure they are executed with the correct runtime handler.

Overall, the Containerd Shim Spin represents a significant advancement in integrating Wasm workloads into Kubernetes clusters, enhancing the versatility and capabilities of container orchestration.
