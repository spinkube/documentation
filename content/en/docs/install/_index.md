---
title: Installation
description: Before you can use SpinKube, you'll need to get it installed. We have several complete installation guides that covers all the possibilities; these guides will guide you through the process of installing SpinKube on your Kubernetes cluster.
weight: 20
---

## SpinKube Project Compatibility Matrix

All versions are backwards compatible, so using a new Spin Operator on an older Spin containerd shim should not break the execution of an application; however, not all new features added to the `SpinApp` custom resource may be available to the shim. For example, OTEL support for monitoring Spin applications was added to the shim in `v0.15.0` and the ability to pipe OpenTelemetry parameters to the shim from a `SpinApp` was added in the Spin Operator `v0.3.0`. This means that people using the `v0.3.0` operator with a shim version less than `v0.15.0` may expect OTEL to be configured for their Spin app.

## Spin Operator and Shim Feature Map

At time, features are added to the Spin Runtime that are added to the shim and can be enabled through the Spin Operator.

| Feature | SpinApp field | Shim Version | Spin Operator Version | `spin kube` plugin version |
| -- | -- | -- | -- |
| OTEL Traces | `otel` | v0.15.0 | v0.3.0 | NA |
| Selective Deployment | `components` | v0.17.0 | v0.4.0 | v0.4.0 |

## Shim and Spin Version Map

| **shim version** | v0.12.0                                                       | v0.13.0                                                       | v0.14.0                                                       | v0.14.1                                                       | v0.15.0                                                       | v0.15.1                                                       | v0.16.0                                                       |
|------------------|---------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------------|
| **spin**         | [v2.2.0](https://github.com/fermyon/spin/releases/tag/v2.2.0) | [v2.3.1](https://github.com/fermyon/spin/releases/tag/v2.3.1) | [v2.4.2](https://github.com/fermyon/spin/releases/tag/v2.4.2) | [v2.4.3](https://github.com/fermyon/spin/releases/tag/v2.4.3) | [v2.6.0](https://github.com/fermyon/spin/releases/tag/v2.6.0) | [v2.6.0](https://github.com/fermyon/spin/releases/tag/v2.6.0) | [v2.6.0](https://github.com/fermyon/spin/releases/tag/v2.6.0) |
