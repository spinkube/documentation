---
title: Publish-Subscribe With Redis
description: Learn how to create a Spin application that responds to messages on pub-sub Redis channels and runs in Kubernetes
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## Prerequisites

For this tutorial, we will be using:
- [Spin](https://developer.fermyon.com/spin/v2/install) to build and deploy our event-driven WebAssembly application,
- [Redis](https://redis.io/docs/install/install-redis/) to generate events in our real-time messaging scenario, and
- [Rancher Desktop](https://rancherdesktop.io/) to manage Kubernetes on our Desktop. ([This page](../../spin-operator/tutorials/integrating-with-rancher-desktop.md) documents integrating Rancher Desktop and SpinKube.)

## Create a Kubernetes Cluster

First, we create our Kubernetes cluster:

```bash
k3d cluster create wasm-cluster --image ghcr.io/spinkube/containerd-shim-spin/k3d:v0.13.1 -p "8081:80@loadbalancer" --agents 2
```

## Install CRDs for SpinKube

Next, we apply the necessary Custom Resource Definitions (CRDs) to our Kubernetes cluster:

```bash
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.crds.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.runtime-class.yaml
kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.1.0/spin-operator.shim-executor.yaml
```

## Install Spin Operator 

Then, we install Spin Operator which handles the `SpinApp` application that we are about to create:

```bash
helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --version 0.1.0 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator
```

## Redis

Let's dive in and get Redis sorted because we are going to need information about our Redis installation in our Spin application's config. We will use the following `helm` commands to get the job done:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-redis bitnami/redis
```

The `helm` installation process from above prints a lot of useful information to the terminal. For example, the endpoints to communicate with Redis (read/write vs read-only):

```bash
my-redis-master.default.svc.cluster.local for read/write operations (port 6379)
my-redis-replicas.default.svc.cluster.local for read-only operations (port 6379)
```

In addition, there are pre-written commands that you can cut and paste. For example:

```bash
export REDIS_PASSWORD=$(kubectl get secret --namespace default my-redis -o jsonpath="{.data.redis-password}" | base64 -d)
```

Go ahead and run the command above to set the password. And, if need be, you can run the following command to see the actual password printed in your terminal:

```bash
echo $REDIS_PASSWORD
```

## Create a Redis Message Handler Using Rust

We use Spin's convenient `redis-rust` template to scaffold our Rust-based Redis message handler:

```bash
spin new -t redis-rust redis-message-handler
```

The command above will provide the prompts for you to add the Description, Redis address and Redis channel (We use the `my-redis-master.default.svc.cluster.local` from above to help configure the Redis address, and the channel is arbitrary i.e. `channel-one`):

```bash
Description: Redis message handler using Rust
Redis address[redis://localhost:6379]: redis://my-redis-master.default.svc.cluster.local:6379
Redis channel: channel-one
```

## Configure Spin Application

We change into our application directory, and can see the layout that Spin has scaffolded for us:

```bash
cd redis-message-handler
tree .
```

The above `tree .` command, produces the following output:

```bash
.
├── Cargo.toml
├── spin.toml
└── src
    └── lib.rs
```

If we open the application manifest (`spin.toml` file) we see that Spin has already pre-populated the [Redis trigger configuration](https://developer.fermyon.com/spin/v2/redis-trigger#the-spin-redis-trigger):

```toml
// --snip --
[application.trigger.redis]
address = "redis://my-redis-master.default.svc.cluster.local:6379"

[[trigger.redis]]
channel = "channel-one"
component = "redis-message-handler"
// --snip --
```

By default, Spin does not authenticate to Redis. You can work around this by providing the password in the `redis://` URL. For example: `address = "redis://:p4ssw0rd@localhost:6379"`

> Do not use passwords in code committed to version control systems.

## Application Logic

In this example, we want to write the logic for our Spin application to listen to messages published on `channel-one`. So, we open the `src/lib.rs` file and paste the following code:

```rust
use anyhow::Result;
use bytes::Bytes;
use spin_sdk::redis_component;
use std::str::from_utf8;

/// A simple Spin Redis component.
#[redis_component]
fn on_message(message: Bytes) -> Result<()> {
    println!("{}", from_utf8(&message)?);
    Ok(())
}
```

## Build

With the logic and configuration in place, we can build the Spin application:

```bash
spin build
```

## Publish

We will now push the application image to a registry. You can use any container registry you prefer (like DockerHub). But for this tutorial, we’ll use a simple one that does not require authentication:

```bash
spin registry push ttl.sh/redis-message-handler:0.1.0
```

To read the configuration we can use the `spin scaffold` command:

```bash
spin kube scaffold --from ttl.sh/redis-message-handler:0.1.0
```

As we can see, our `SpinApp` is all set and using the `containerd-shim-spin` executor:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: redis-message-handler
spec:
  image: "ttl.sh/redis-message-handler:0.1.0"
  executor: containerd-shim-spin
  replicas: 2
```

## Deploy

We deploy our application to our cluster using the `spin kube` command:

```bash
spin kube deploy --from ttl.sh/redis-message-handler:0.1.0
```

## Test

We want to run the Redis server and publish a message. First, we run the Redis container image:

```bash
kubectl run --namespace default redis-client --restart='Never'  --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:7.2.4-debian-12-r9 --command -- sleep infinity
```

Then, we want to attach to the pod:

```bash
kubectl exec --tty -i redis-client --namespace default -- bash
```

And, access the Redis CLI from inside the cluster:

```bash
REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h my-redis-master
```

Which then provides us with the prompt (`my-redis-master:6379>`) at which point we can publish our message:

```bash
my-redis-master:6379> PUBLISH channel-one message-one
```