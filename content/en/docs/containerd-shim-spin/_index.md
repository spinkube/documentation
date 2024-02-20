---
title: containerd-shim-spin
description: The Containerd Shim Spin is a project that integrates WebAssembly (Wasm) and WASI workloads into Kubernetes.
categories: []
tags: []
weight: 80
---

The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin) provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment.