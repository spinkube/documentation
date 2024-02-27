---
title: Autoscaler Support
description: A tutorial to show how autoscaler support can be enabled via the spin k8s command
date: 2024-02-26
weight: 100
categories: [Spin Plugin k8s]
tags: [Autoscaler Support]
---

## Autoscaler support

Horizontal Pod Autoscaler (HPA) scales Kubernetes pods based on CPU or memory utilization. This HPA scaling can be implemented via the Spin Plugin k8s by setting the `--autoscaler hpa` option. This page deals exclusively with autoscaling via the Spin Plugin k8s. For more general information about scaling with HPA, please see the Spin Operator's [Scaling with HPA section](../../spin-operator/tutorials/scaling-with-hpa.md)

## HPA

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi
```

### Setting min/max replicas

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi -replicas 1 --max-replicas 10
```

### CPU/memory limits and CPU/memory requests can be set together

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --cpu-request 50m --memory-request 64Mi
```

```text
IMPORTANT!
    CPU/memory requests are optional and will default to the CPU/memory limit if not set.
    CPU/memory requests must be lower than their respective CPU/memory limit.
```

### Setting the target CPU utilization

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --autoscaler-target-cpu-utilization 50
```

### Setting the target memory utilization

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --autoscaler-target-memory-utilization 50
```

## KEDA

Kubernetes Event-driven Autoscaling (KEDA), which allows for scaling based on events from various sources like queues, databases, or streaming platforms, can be enabled by setting the `--autoscaler keda` option:

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler keda --cpu-limit 100m --memory-limit 128Mi -replicas 1 --max-replicas 10
```

This KEDA example implements scaling via the Spin Plugin k8s, for more information about scaling with KEDA in general, please see the Spin Operator's [Scaling with KEDA section](../../spin-operator/tutorials/scaling-with-keda.md)
