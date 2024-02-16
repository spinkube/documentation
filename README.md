# Overview

## Containerd Shim Spin

The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin) provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment.

## Runtime Class Manager (Containerd Shim Lifecycle Operator)

The [Runtime Class Manager, also known as the Containerd Shim Lifecycle Operator](https://github.com/spinkube/runtime-class-manager), is designed to automate and manage the lifecycle of containerd shims in a Kubernetes environment. This includes tasks like installation, update, removal, and configuration of shims, reducing manual errors and improving reliability in managing WebAssembly (Wasm) workloads and other containerd extensions.

## Spin Kubernetes (k8s) Plugin

The [Spin k8s plugin](https://github.com/spinkube/spin-plugin-k8s) is designed to enhance Kubernetes by enabling the execution of Wasm modules directly within a Kubernetes cluster. This plugin works by integrating with containerd shims, allowing Kubernetes to manage and run Wasm workloads in a way similar to traditional container workloads.

## Spin Operator

The [Spin Operator](https://github.com/spinkube/spin-operator/) enables deploying Spin applications to Kubernetes. The foundation of this project is built using the [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) framework. Spin Operator defines Spin App Custom Resource Definitions (CRDs). Spin Operator watches SpinApp Custom Resources e.g. Spin app image, replicas, schedulers and other user-defined values and realizes the desired state in the Kubernetes cluster. Spin Operator introduces a host of functionality such as resource-based scaling event-driven scaling and much more.


