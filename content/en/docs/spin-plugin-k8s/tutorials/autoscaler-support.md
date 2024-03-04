---
title: Autoscaler Support
description: A tutorial to show how autoscaler support can be enabled via the spin k8s command
date: 2024-02-26
weight: 100
categories: [guides]
tags: [tutorial, autoscaling]
---

## Horizontal autoscaling support

In Kubernetes, a horizontal autoscaler automatically updates a workload resource (such as a
Deployment or StatefulSet) with the aim of automatically scaling the workload to match demand.

Horizontal scaling means that the response to increased load is to deploy more resources. This is
different from vertical scaling, which for Kubernetes would mean assigning more memory or CPU to the
resources that are already running for the workload.

If the load decreases, and the number of resources is above the configured minimum, a horizontal
autoscaler would instruct the workload resource (the Deployment, StatefulSet, or other similar
resource) to scale back down.

The Kubernetes plugin for Spin includes autoscaler support, which allows you to tell Kubernetes when
to scale your Spin application up or down based on demand. This tutorial will show you how to enable
autoscaler support via the `spin k8s scaffold` command.

### Prerequisites

Regardless of what type of autoscaling is used, you must determine how you want your application to
scale by answering the following questions:

1. Do you want your application to scale based upon system metrics (CPU and memory utilization) or
   based upon events (like messages in a queue or rows in a database)?
1. If you application scales based on system metrics, how much CPU and memory each instance does
   your application need to operate?

### Choosing an autoscaler

The Kubernetes plugin for Spin supports two types of autoscalers: Horizontal Pod Autoscaler (HPA)
and Kubernetes Event-driven Autoscaling (KEDA). The choice of autoscaler depends on the requirements
of your application.

#### Horizontal Pod Autoscaling (HPA)

Horizontal Pod Autoscaler (HPA) scales Kubernetes pods based on CPU or memory utilization. This HPA
scaling can be implemented via the Spin Plugin k8s by setting the `--autoscaler hpa` option. This
page deals exclusively with autoscaling via the Spin Plugin k8s.

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi
```

Horizontal Pod Autoscaling is built-in to Kubernetes and does not require the installation of a
third-party runtime. For more general information about scaling with HPA, please see the Spin
Operator's [Scaling with HPA section](../../spin-operator/tutorials/scaling-with-hpa.md)

#### Kubernetes Event-driven Autoscaling (KEDA)

Kubernetes Event-driven Autoscaling (KEDA) is an extension of Horizontal Pod Autoscaling (HPA). On
top of allowing to scale based on CPU or memory utilization, KEDA allows for scaling based on events
from various sources like messages in a queue, or the number of rows in a database.

KEDA can be enabled by setting the `--autoscaler keda` option:

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler keda --cpu-limit 100m --memory-limit 128Mi -replicas 1 --max-replicas 10
```

Using KEDA to autoscale your Spin applications requires the installation of the [KEDA
runtime](https://keda.sh/) into your Kubernetes cluster. For more information about scaling with
KEDA in general, please see the Spin Operator's [Scaling with KEDA
section](../../spin-operator/tutorials/scaling-with-keda.md)

### Setting min/max replicas

The `--replicas` and `--max-replicas` options can be used to set the minimum and maximum number of
replicas for your application. The `--replicas` option defaults to 2 and the `--max-replicas` option
defaults to 3.

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi -replicas 1 --max-replicas 10
```

### Setting CPU/memory limits and CPU/memory requests

If the node where an application is running has enough of a resource available, it's possible (and
allowed) for that application to use more resource than its resource request for that resource
specifies. However, an application is not allowed to use more than its resource limit.

For example, if you set a memory request of 256 MiB, and that application is scheduled to a node
with 8GiB of memory and no other appplications, then the application can try to use more RAM.

If you set a memory limit of 4GiB for that application, the webassembly runtime will enforce that
limit. The runtime prevents the application from using more than the configured resource limit. For
example: when a process in the application tries to consume more than the allowed amount of memory,
the webassembly runtime terminates the process that attempted the allocation with an out of memory
(OOM) error.

The `--cpu-limit`, `--memory-limit`, `--cpu-request`, and `--memory-request` options can be used to
set the CPU and memory limits and requests for your application. The `--cpu-limit` and
`--memory-limit` options are required, while the `--cpu-request` and `--memory-request` options are
optional.

It is important to note the following:

- CPU/memory requests are optional and will default to the CPU/memory limit if not set.
- CPU/memory requests must be lower than their respective CPU/memory limit.
- If you specify a limit for a resource, but do not specify any request, and no admission-time
  mechanism has applied a default request for that resource, then Kubernetes copies the limit you
  specified and uses it as the requested value for the resource.

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --cpu-request 50m --memory-request 64Mi
```

### Setting target utilization

Target utilization is the percentage of the resource that you want to be used before the autoscaler
kicks in. The autoscaler will check the current resource utilization of your application against the
target utilization and scale your application up or down based on the result.

Target utilization is based on the average resource utilization across all instances of your
application. For example, if you have 3 instances of your application, the target CPU utilization is
50%, and each application is averaging 80% CPU utilization, the autoscaler will continue to increase
the number of instances until all instances are averaging 50% CPU utilization.

To scale based on CPU utilization, use the `--autoscaler-target-cpu-utilization` option:

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --autoscaler-target-cpu-utilization 50
```

To scale based on memory utilization, use the `--autoscaler-target-memory-utilization` option:

```sh
spin k8s scaffold --from user-name/app-name:latest --autoscaler hpa --cpu-limit 100m --memory-limit 128Mi --autoscaler-target-memory-utilization 50
```
