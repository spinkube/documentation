---
title: Uninstall
description: How to uninstall custom resources and Spin Operator from your Cluster
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

These are commands to delete, uninstall and undeploy resources.

## Delete (CRs)

The following command will delete the instances (CRs) from the cluster:

```console
kubectl delete -k config/samples/
```

## Delete APIs(CRDs)

The following command will uninstall CRDs from the Kubernetes cluster specified in `~/.kube/config`:

```console
make uninstall
```

> Call with `ignore-not-found=true` to ignore resource not found errors during deletion.

## UnDeploy

The following command will undeploy the controller from the Kubernetes cluster specified in `~/.kube/config`:

```console
make undeploy
```

> Call with `ignore-not-found=true` to ignore resource not found errors during deletion.
