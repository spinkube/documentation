---
title: Monitoring your app
description: How to view telemetry data from your Spin apps running in SpinKube.
weight: 13
---

This topic guide shows you how to configure SpinKube so your Spin apps export observability data. This data will export to an OpenTelemetry collector which will send it to Jaeger.

## Prerequisites

Please ensure you have the following tools installed before continuing:

- A Kubernetes cluster running SpinKube. See the [installation guides](https://www.spinkube.dev/docs/install/) for more information
- The [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- The [Helm CLI](https://helm.sh)

## About OpenTelemetry Collector

From the OpenTelemetry [documentation](https://opentelemetry.io/docs/collector/):
>> The OpenTelemetry Collector offers a vendor-agnostic implementation of how to receive, process and export telemetry data. It removes the need to run, operate, and maintain multiple agents/collectors. This works with improved scalability and supports open source observability data formats (e.g. Jaeger, Prometheus, Fluent Bit, etc.) sending to one or more open source or commercial backends.

In our case, the OpenTelemetry collector serves as a single endpoint to receive and route telemetry data, letting us to monitor metrics, traces, and logs via our preferred UIs.

## About Jaeger

From the Jaeger [documentation](https://www.jaegertracing.io/docs/):
>> Jaeger is a distributed tracing platform released as open source by Uber Technologies. With Jaeger you can: Monitor and troubleshoot distributed workflows, Identify performance bottlenecks, Track down root causes, Analyze service dependencies

Here, we have the OpenTelemetry collector send the trace data to Jaeger.

## Deploy OpenTelemetry Collector

First, add the OpenTelemetry collector Helm repository:

```sh
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
```

Next, deploy the OpenTelemetry collector to your cluster:

```sh
helm upgrade --install otel-collector open-telemetry/opentelemetry-collector \
    --set image.repository="otel/opentelemetry-collector-k8s" \
    --set nameOverride=otel-collector \
    --set mode=deployment \
    --set config.exporters.otlp.endpoint=http://jaeger-collector.default.svc.cluster.local:4317 \
    --set config.exporters.otlp.tls.insecure=true \
    --set config.service.pipelines.traces.exporters[0]=otlp \
    --set config.service.pipelines.traces.processors[0]=batch \
    --set config.service.pipelines.traces.receivers[0]=otlp \
    --set config.service.pipelines.traces.receivers[1]=jaeger
```

## Deploy Jaeger

Next, add the Jaeger Helm repository:

```sh
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
```

Then, deploy Jaeger to your cluster:

```sh
helm upgrade --install jaeger jaegertracing/jaeger \
    --set provisionDataStore.cassandra=false \
    --set allInOne.enabled=true \
    --set agent.enabled=false \
    --set collector.enabled=false \
    --set query.enabled=false \
    --set storage.type=memory
```

## Configure the SpinAppExecutor

The `SpinAppExecutor` resource determines how Spin applications are deployed in the cluster. The following configuration will ensure that any `SpinApp` resource using this executor will send telemetry data to the OpenTelemetry collector. To see a comprehensive list of OTel options for the `SpinAppExecutor`, see the [API reference](https://www.spinkube.dev/docs/reference/spin-app-executor/).

Create a file called `executor.yaml` with the following content:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinAppExecutor
metadata:
  name: otel-shim-executor
spec:
  createDeployment: true
  deploymentConfig:
    runtimeClassName: wasmtime-spin-v2
    installDefaultCACerts: true
    otel:
      exporter_otlp_endpoint: http://otel-collector.default.svc.cluster.local:4318
```

To deploy the executor, run:

```sh
kubectl apply -f executor.yaml
```

## Deploy a Spin app to observe

With everything in place, we can now deploy a `SpinApp` resource that uses the executor `otel-shim-executor`.

Create a file called `app.yaml` with the following content:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: otel-spinapp
spec:
  image: ghcr.io/spinkube/spin-operator/cpu-load-gen:20240311-163328-g1121986
  executor: otel-shim-executor
  replicas: 1
```

Deploy the app by running:

```sh
kubectl apply -f app.yaml
```

Congratulations! You now have a Spin app exporting telemetry data.

Next, we need to generate telemetry data for the Spin app to export. Use the below command to port-forward the Spin app:

```sh
kubectl port-forward svc/otel-spinapp 3000:80
```

In a new terminal window, execute a `curl` request:

```sh
curl localhost:3000
```

The request will take a couple of moments to run, but once it's done, you should see an output similar to this:

```
fib(43) = 433494437
```

## Interact with Jaeger

To view the traces in Jaeger, use the following port-forward command:

```sh
kubectl port-forward svc/jaeger-query 16686:16686
```

Then, open your browser and navigate to `localhost:16686` to interact with Jaeger's UI.