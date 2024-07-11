---
title: SpinKube
---

{{< blocks/cover title="Hyper-efficient serverless on Kubernetes, powered by WebAssembly." image_anchor="top" height="full" >}}
<a class="btn btn-lg btn-primary me-3 mb-4" href="/docs">
  Get Started <i class="fas fa-arrow-alt-circle-right ms-2"></i>
</a>
<p class="lead mt-5">SpinKube is an open source project that streamlines developing, deploying and operating WebAssembly workloads in Kubernetes - resulting in delivering smaller, more portable applications and incredible compute performance benefits.</p>
{{< blocks/link-down color="info" >}}
{{< /blocks/cover >}}


{{% blocks/lead color="secondary" %}}

SpinKube combines the <a href="https://github.com/spinkube/spin-operator">Spin operator</a>, <a href="https://github.com/spinkube/containerd-shim-spin">containerd Spin shim</a>, and the <a href="https://github.com/spinkube/runtime-class-manager">runtime class manager</a> (formerly <a href="https://kwasm.sh/">KWasm</a>) open source projects with contributions from Microsoft, SUSE, Liquid Reply, and Fermyon. By running applications at the Wasm abstraction layer, SpinKube gives developers a more powerful, efficient and scalable way to optimize application delivery on Kubernetes.


### Made with Contributions from:

|![Microsoft](logo-microsoft.png)|![Liquid Reply](logo-liquidreply.png)|![SUSE](logo-suse.png)|![Fermyon](logo-fermyon.png)|
|---|---|---|---|

### Overview

**Containerd Shim Spin**
The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin) provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment.

**Runtime Class Manager**
The [Runtime Class Manager, also known as the Containerd Shim Lifecycle Operator](https://github.com/spinkube/runtime-class-manager), is designed to automate and manage the lifecycle of containerd shims in a Kubernetes environment. This includes tasks like installation, update, removal, and configuration of shims, reducing manual errors and improving reliability in managing WebAssembly (Wasm) workloads and other containerd extensions.

**Spin Plugin for Kubernetes**
The [Spin plugin for Kubernetes](https://github.com/spinkube/spin-plugin-kube) is designed to enhance Kubernetes by enabling the execution of Wasm modules directly within a Kubernetes cluster. This plugin works by integrating with containerd shims, allowing Kubernetes to manage and run Wasm workloads in a way similar to traditional container workloads.

**Spin Operator**
The [Spin Operator](https://github.com/spinkube/spin-operator/) enables deploying Spin applications to Kubernetes. The foundation of this project is built using the [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) framework. Spin Operator defines Spin App Custom Resource Definitions (CRDs). Spin Operator watches SpinApp Custom Resources e.g. Spin app image, replicas, schedulers and other user-defined values and realizes the desired state in the Kubernetes cluster. Spin Operator introduces a host of functionality such as resource-based scaling event-driven scaling and much more.

**Spin Trigger MQTT**
[Spin Trigger MQTT](https://github.com/spinkube/spin-trigger-mqtt/) is an MQTT trigger designed specifically for Spin. It enables seamless integration between Spin and MQTT-based systems, allowing you to automate workflows and trigger actions based on MQTT messages.

{{% /blocks/lead %}}
