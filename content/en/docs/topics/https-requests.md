---
title: Making HTTPS Requests
description: Configure Spin Apps to allow HTTPS requests.
date: 2024-09-03
categories: [Spin Operator]
tags: [Tutorials]
weight: 11
aliases:
- /docs/spin-operator/tutorials/https-requests
---

To enable HTTPS requests, the [executor](https://www.spinkube.dev/docs/glossary/#spin-app-executor-crd) must be configured to use certificates. SpinKube can be configured to use either default or custom certificates.

If you make a request without properly configured certificates, you'll encounter an error message that reads: `error trying to connect: unexpected EOF (unable to get local issuer certificate)`.

## Using default certificates

SpinKube can generate a default CA certificate bundle by setting `installDefaultCACerts` to `true`. This creates a secret named `spin-ca` populated with curl's [default bundle](https://curl.se/ca/cacert.pem). You can specify a custom secret name by setting `caCertSecret`.

```yaml
apiVersion: core.spinkube.dev/v1alpha1
kind: SpinAppExecutor
metadata:
  name: containerd-shim-spin
spec:
  createDeployment: true
  deploymentConfig:
    runtimeClassName: wasmtime-spin-v2
    installDefaultCACerts: true
```

Apply the executor using kubectl:

```console
kubectl apply -f myexecutor.yaml
```

## Using custom certificates

Create a secret from your certificate file:

```console
kubectl create secret generic my-custom-ca --from-file=ca-certificates.crt
```

Configure the executor to use the custom certificate secret:

```yaml
apiVersion: core.spinkube.dev/v1alpha1
kind: SpinAppExecutor
metadata:
  name: containerd-shim-spin
spec:
  createDeployment: true
  deploymentConfig:
    runtimeClassName: wasmtime-spin-v2
    caCertSecret: my-custom-ca
```

Apply the executor using kubectl:

```console
kubectl apply -f myexecutor.yaml
```
