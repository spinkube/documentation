---
title: SpinKube
---

{{< blocks/cover title="Welcome to SpinKube" image_anchor="top" height="full" >}}
<a class="btn btn-lg btn-primary me-3 mb-4" href="/docs/">
  SpinKube Documentation <i class="fas fa-arrow-alt-circle-right ms-2"></i>
</a>
<p class="lead mt-5">A new open source project that streamlines the experience of developing, deploying, and operating Wasm workloads on Kubernetes.</p>
{{< blocks/link-down color="info" >}}
{{< /blocks/cover >}}


{{% blocks/lead color="primary" %}}

SpinKube comprises the following open source projects.

<br />
<br />

<u>**Containerd Shim Spin**</u>

The [Containerd Shim Spin repository](https://github.com/spinkube/containerd-shim-spin) provides shim implementations for running WebAssembly ([Wasm](https://webassembly.org/)) / Wasm System Interface ([WASI](https://github.com/WebAssembly/WASI)) workloads using [runwasi](https://github.com/deislabs/runwasi) as a library, whereby workloads built using the [Spin framework](https://github.com/fermyon/spin) can function similarly to container workloads in a Kubernetes environment.

<br />
<br />

<u>**Runtime Class Manager**</u>

The [Runtime Class Manager, also known as the Containerd Shim Lifecycle Operator](https://github.com/spinkube/runtime-class-manager), is designed to automate and manage the lifecycle of containerd shims in a Kubernetes environment. This includes tasks like installation, update, removal, and configuration of shims, reducing manual errors and improving reliability in managing WebAssembly (Wasm) workloads and other containerd extensions.

<br />
<br />

<u>**Spin Kubernetes (k8s) Plugin**</u>

The [Spin k8s plugin](https://github.com/spinkube/spin-plugin-k8s) is designed to enhance Kubernetes by enabling the execution of Wasm modules directly within a Kubernetes cluster. This plugin works by integrating with containerd shims, allowing Kubernetes to manage and run Wasm workloads in a way similar to traditional container workloads.

<br />
<br />

<u>**Spin Operator**</u>

The [Spin Operator](https://github.com/spinkube/spin-operator/) enables deploying Spin applications to Kubernetes. The foundation of this project is built using the [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) framework. Spin Operator defines Spin App Custom Resource Definitions (CRDs). Spin Operator watches SpinApp Custom Resources e.g. Spin app image, replicas, schedulers and other user-defined values and realizes the desired state in the Kubernetes cluster. Spin Operator introduces a host of functionality such as resource-based scaling event-driven scaling and much more.

{{% /blocks/lead %}}


{{% blocks/section color="dark" type="row" %}}
{{% blocks/feature icon="fa-lightbulb" title="New chair metrics!" %}}
The Goldydocs UI now shows chair size metrics by default.

Please follow this space for updates!
{{% /blocks/feature %}}


{{% blocks/feature icon="fab fa-github" title="Contributions welcome!" url="https://github.com/google/docsy-example" %}}
We do a [Pull Request](https://github.com/google/docsy-example/pulls) contributions workflow on **GitHub**. New users are always welcome!
{{% /blocks/feature %}}


{{% blocks/feature icon="fab fa-twitter" title="Follow us on Twitter!" url="https://twitter.com/docsydocs" %}}
For announcement of latest features etc.
{{% /blocks/feature %}}


{{% /blocks/section %}}


{{% blocks/section %}}
This is the second section
{.h1 .text-center}
{{% /blocks/section %}}


{{% blocks/section type="row" %}}

{{% blocks/feature icon="fab fa-app-store-ios" title="Download **from AppStore**" %}}
Get the Goldydocs app!
{{% /blocks/feature %}}

{{% blocks/feature icon="fab fa-github" title="Contributions welcome!"
    url="https://github.com/google/docsy-example" %}}
We do a [Pull Request](https://github.com/google/docsy-example/pulls)
contributions workflow on **GitHub**. New users are always welcome!
{{% /blocks/feature %}}

{{% blocks/feature icon="fab fa-twitter" title="Follow us on Twitter!"
    url="https://twitter.com/GoHugoIO" %}}
For announcement of latest features etc.
{{% /blocks/feature %}}

{{% /blocks/section %}}


{{% blocks/section %}}
This is the another section
{.h1 .text-center}
{{% /blocks/section %}}