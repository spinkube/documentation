---
title: Runtime Configuration
description: Learn how to supply Spin Apps with Runtime Configuration
date: 2024-07-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 12
---

Configuration for many Spin application features can be supplied dynamically at runtime, for example to supply alternate providers for application variables, SQL storage, Key Value storage and Serverless AI. This article demonstrates how to provide such configuration in the context of SpinApps running on SpinKube.

# Application Variables

These are the available [application variable providers](https://developer.fermyon.com/spin/v2/dynamic-configuration#application-variables-runtime-configuration) for Spin applications:

- Environment
- [Vault](https://www.vaultproject.io/)
- [Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault)

These translate to the following configuration options in SpinKube:

### Variables

Direct application variable configuration for a SpinApp can be supplied via `spec.variables` configuration on a [SpinApp resource]({{< ref "glossary#spin-app-crd" >}}). Under the hood, the Spin Operator translates this configuration into environment variables in the SpinApp Pod environment, thus utilizing this environment provider.

For more information on assigning variables for a SpinApp using this method, see [Assigning Variables](./assigning-variables.md).

### Loading from a Kubernetes Secret

Currently, application variable provider config for [Vault](https://developer.fermyon.com/spin/v2/dynamic-configuration#vault-application-variable-provider) or [Azure Key Vault](https://developer.fermyon.com/spin/v2/dynamic-configuration#azure-key-vault-application-variable-provider) can be provided generically via a Kubernetes secret. The
secret should have a single key named "runtime-config.toml" that contains the base64-encoded runtime config. The name of the secret is then provided as the value of `spec.runtimeConfig.loadFromSecret`.

The secret can be created manually via `kubectl` or you can utilize the [kube plugin](https://spinkube.dev/docs/topics/packaging/#scaffolding-spin-apps) to automatically scaffold the secret at time of SpinApp creation via the `--runtime-config-file` option.

### Example: Vault Provider

Here is an example manifest showing an application and corresponding secret:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: vault-provider
spec:
  image: "ttl.sh/vault-provider:3m"
  executor: containerd-shim-spin
  replicas: 1
  runtimeConfig:
    loadFromSecret: vault-provider-runtime-config
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-provider-runtime-config
type: Opaque
data:
  runtime-config.toml: W1tjb25maWdfcHJvdmlkZXJdXQp0eXBlID0gInZhdWx0Igp1cmwgPSAiaHR0cHM6Ly9teS12YXVsdC1zZXJ2ZXI6ODIwMCIKdG9rZW4gPSAibXlfdG9rZW4iCm1vdW50ID0gImFkbWluL3NlY3JldCIK
```

> Hint: you can see the runtime-config.toml contents by base64-decoding the encoded string above.

# SQL Storage

SpinKube has first-class support for [SQLite database provider configuration](https://developer.fermyon.com/spin/v2/dynamic-configuration#sqlite-storage-runtime-configuration), which can be provided via the `spec.runtimeConfig.sqliteDatabases` section of a SpinApp. SQLite database options include on-disk or via [libSQL](https://libsql.org/) providers like [Turso](https://turso.tech/).

### Example: LibSQL configuration

The following example shows SQLite runtime configuration using the `libsql` type:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: sqlite-app
spec:
  image: "ttl.sh/sqlite-app:3h"
  replicas: 1
  executor: containerd-shim-spin
  runtimeConfig:
    sqliteDatabases:
      - name: "default"
        type: "libsql"
        options:
          - name: "url"
            value: "https://sensational-penguin-ahacker.libsql.example.com"
          - name: "token"
            valueFrom:
              secretKeyRef:
                name: "my-super-secret"
                key: "turso-token"
```

# Key Value Storage

[Key Value storage configuration](https://developer.fermyon.com/spin/v2/dynamic-configuration#key-value-store-runtime-configuration) can be provided via the `spec.runtimeConfig.keyValueStores` section of a SpinApp. Some examples of alternate Key Value storage providers include [Redis](https://developer.fermyon.com/spin/v2/dynamic-configuration#redis-key-value-store-provider) and [Azure CosmosDB](https://developer.fermyon.com/spin/v2/dynamic-configuration#azure-cosmosdb-key-value-store-provider).

### Example: Redis

The following example manifest shows an app configured with Redis provider configuration:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: kv-explorer
spec:
  image: "ttl.sh/kv-explorer:3h"
  replicas: 1
  executor: containerd-shim-spin
  runtimeConfig:
    keyValueStores:
      - name: "default"
        type: "redis"
        options:
          - name: "url"
            valueFrom:
              secretKeyRef:
                name: "my-super-secret"
                key: "redis-full-url"
```

# Serverless AI

Spin can be configured to utilize [remote compute for LLM inferencing](https://developer.fermyon.com/spin/v2/dynamic-configuration#llm-runtime-configuration). This configuration can be provided to an application via the `spec.runtimeConfig.llmCompute` section of a SpinApp resource.

### Example: LLM proxy app

The following example manifest shows an app configured to utlize remote compute via an LLM proxy service:

```yaml
apiVersion: core.spinoperator.dev/v1alpha1
kind: SpinApp
metadata:
  name: llm-app
spec:
  image: "ttl.sh/llm-app:3h"
  replicas: 1
  executor: containerd-shim-spin
  runtimeConfig:
    llmCompute:
      type: "remote_http"
      options:
        - name: "url"
          value: "https://llm-proxy.fermyon.app"
        - name: "auth_token"
          valueFrom:
            secretKeyRef:
              name: "my-super-secret"
              key: "llm-token"
```
