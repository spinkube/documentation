# Overview

## Containerd Shim Spin

The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin) provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment.

## Runtime Class Manager (Containerd Shim Lifecycle Operator)

The [Runtime Class Manager, also known as the Containerd Shim Lifecycle Operator](https://github.com/spinkube/runtime-class-manager), is designed to automate and manage the lifecycle of containerd shims in a Kubernetes environment. This includes tasks like installation, update, removal, and configuration of shims, reducing manual errors and improving reliability in managing WebAssembly (Wasm) workloads and other containerd extensions.

## Spin Kubernetes (k8s) Plugin

The [Spin k8s plugin](https://github.com/spinkube/spin-plugin-k8s) is designed to enhance Kubernetes by enabling the execution of Wasm modules directly within a Kubernetes cluster. This plugin works by integrating with containerd shims, allowing Kubernetes to manage and run Wasm workloads in a way similar to traditional container workloads.

## Spin Operator

The [Spin Operator](https://github.com/spinkube/spin-operator/) enables deploying Spin applications to Kubernetes. The foundation of this project is built using the [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) framework. Spin Operator defines Spin App Custom Resource Definitions (CRDs). Spin Operator watches SpinApp Custom Resources e.g. Spin app image, replicas, schedulers and other user-defined values and realizes the desired state in the Kubernetes cluster. Spin Operator introduces a host of functionality such as resource-based scaling event-driven scaling and much more.

# Running Documentation Locally

Check out this repository and run using the `hugo serve` command:

```bash
$ cd ~
$ git clone git@github.com:spinkube/documentation.git
$ cd documentation
$ hugo server

Watching for changes in documentation/{assets,content,layouts,package.json}
Watching for config changes in documentation/hugo.toml, documentation/go.mod
Start building sites … 
hugo v0.122.0-b9a03bd59d5f71a529acb3e33f995e0ef332b3aa+extended darwin/amd64 BuildDate=2024-01-26T15:54:24Z VendorInfo=brew


                   | NO | EN   
-------------------+----+------
  Pages            | 95 | 114  
  Paginator pages  |  0 |   0  
  Non-page files   |  1 |   3  
  Static files     | 30 |  30  
  Processed images |  2 |   9  
  Aliases          |  1 |   3  
  Sitemaps         |  2 |   1  
  Cleaned          |  0 |   0  

Built in 1121 ms
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at //localhost:1313/ (bind address 127.0.0.1) 
Press Ctrl+C to stop
```

View the website at [localhost:1313](http://localhost:1313/docs/overview/)

![Screenshot 2024-02-19 at 14 51 24](https://github.com/spinkube/documentation/assets/9831342/98fef78c-3770-42c4-be1c-88d7282130e7)




