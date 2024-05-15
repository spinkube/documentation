---
title: Known Issues
description: Known Issues
categories: [Containerd Shim Spin]
tags: [Known Issues]
weight: 100
---

This article describes a list of known issues and limitations with running Spin applications on Kubernetes, using SpinKube.

- [Stuck Spin Apps After Running `kubectl delete`](#stuck-spin-apps-after-running-kubectl-delete)


### Stuck Pod After Running `kubectl delete`

**Symptom**: After running `kubectl delete pod <your-spin-app-name>` on your desired pod, the resource remains stuck. This may be because there are unknown tasks in the container runtime that are not being cleaned up properly (see [#39](https://github.com/spinkube/containerd-shim-spin/issues/39))

**Mitigation**: 