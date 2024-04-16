---
title: Publish-Subscribe With Valkey
description: Learn how to create a Spin App that responds to messages on pub-sub Valkey channels and runs in Kubernetes
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

## Prerequisites

For this tutorial, we will be using:
- [Spin](https://developer.fermyon.com/spin/v2/install) to build and deploy our event-driven WebAssembly application, and
- [Valkey](https://valkey.io/docs/) to generate events in our real-time messaging scenario.

## Create a Kubernetes Cluster

First, we create our Kubernetes cluster:

```bash
k3d cluster create wasm-cluster --image ghcr.io/spinkube/containerd-shim-spin/k3d:v0.13.1 -p "8081:80@loadbalancer" --agents 2
```

## Install CRDs for SpinKube

Next, we install cert-manager and apply the necessary Runtime Class and Custom Resource Definitions (CRDs) to our Kubernetes cluster:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
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

## Valkey

Let's dive in and install Valkey because we need information about the Valkey instance to configure our Spin App. We will use the following helm commands to get the job done:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-Valkey bitnami/Valkey
```

The `helm` installation process from above prints a lot of useful information to the terminal. For example, the endpoints to communicate with Valkey (read/write vs read-only):

```bash
my-Valkey-master.default.svc.cluster.local for read/write operations (port 6379)
my-Valkey-replicas.default.svc.cluster.local for read-only operations (port 6379)
```

In addition, there are pre-written commands that you can copy and paste. For example:

```bash
export Valkey_PASSWORD=$(kubectl get secret --namespace default my-valkey -o jsonpath="{.data.valkey-password}" | base64 -d)
```

Go ahead and run the command above to store the password as an environment variable for the current terminal session. If required, you can print the actual password using:

```bash
echo $VALKEY_PASSWORD
```

## Create a Valkey Message Handler Using Rust

We use Spin's convenient `valkey-rust` template to scaffold our Rust-based Valkey message handler:

```bash
spin new -t redis-rust valkey-message-handler
```

The command above will provide the prompts for you to add the Description, Valkey address and Valkey channel (We use the `my-valkey-master.default.svc.cluster.local` from above to help configure the Valkey address, and the channel is arbitrary i.e. `channel-one`):

```bash
Description: Valkey message handler using Rust
Redis address[valkey://localhost:6379]: valkey://:<password>@my-valkey-master.default.svc.cluster.local:6379
Redis channel: channel-one
```

## Configure Spin Application

We change into our application directory, and can see the layout that Spin has scaffolded for us:

```bash
cd valkey-message-handler
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

If we open the application manifest (`spin.toml` file) we see that Spin has already pre-populated the [Valkey trigger configuration](https://developer.fermyon.com/spin/v2/redis-trigger#the-spin-redis-trigger):

```toml
# --snip --
[application.trigger.redis]
address = "valkey://:password@my-valkey-master.default.svc.cluster.local:6379"

[[trigger.redis]]
channel = "channel-one"
component = "valkey-message-handler"
# --snip --
```

> Do not use passwords in code committed to version control systems.

## Application Logic

In this example, we want to write the logic for our Spin application to listen to messages published on `channel-one`. So, we open the `src/lib.rs` file and paste the following code:

```rust
use anyhow::Result;
use bytes::Bytes;
use spin_sdk::redis_component;
use std::str::from_utf8;

/// A simple Spin Valkey component.
#[redis_component]
fn on_message(message: Bytes) -> Result<()> {
    println!("{}", from_utf8(&message)?);
    // Implement me ...
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
spin registry push ttl.sh/valkey-message-handler:0.1.0
```

> This image will be available for the default time of 24h (because we're using a server tag instead of specifying a duration for the image to live).

To create the Kubernetes deployment manifest we can use the `spin kube scaffold` command:

```bash
spin kube scaffold --from ttl.sh/valkey-message-handler:0.1.0
```

As we can see, our `SpinApp` is all set and using the `containerd-shim-spin` executor:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: valkey-message-handler
spec:
  image: "ttl.sh/valkey-message-handler:0.1.0"
  executor: containerd-shim-spin
  replicas: 2
```

## Deploy

We deploy the Spin App to our Kubernetes cluster by piping the deployment manifest to kubectl:

```bash
spin kube scaffold --from ttl.sh/valkey-message-handler:0.1.0 | kubectl apply -f -
```

## Test

To test the application, we will run an additional container for publishing messages to our Valkey channel:

```bash
kubectl run valkey-client \
  --namespace default  \
  --restart='Never'  \
  --env VALKEY_PASSWORD=$VALKEY_PASSWORD  \
  # TODO new way of installing valkey
  --image docker.io/bitnami/redis:7.2.4-debian-12-r9 \
  --command -- sleep infinity
```

Then, we want to jump into the container using `kubectl exec`:

```bash
kubectl exec --tty -i valkey-client --namespace default -- bash
```

And, access the Valkey CLI from inside the cluster:

```bash
VALKEYCLI_AUTH="$VALKEY_PASSWORD" valkey-cli -h my-valkey-master.default.svc.cluster.local
```

This provides us with the following prompt at which point we can publish our message:

```bash
my-valkey-master.default.svc.cluster.local:6379> PUBLISH channel-one message-one
```