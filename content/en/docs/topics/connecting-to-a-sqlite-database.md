---
title: Connecting to a SQLite database
description: Connect your Spin App to an external SQLite database
date: 2024-07-17
categories: [Spin Operator]
tags: [Tutorials]
weight: 14
---

Spin applications can utilize a [standardized API for persisting data in a SQLite
database](https://developer.fermyon.com/spin/v2/sqlite-api-guide). A default database is created by
the Spin runtime on the local filesystem, which is great for getting an application up and running.
However, this on-disk solution may not be preferable for an app running in the context of SpinKube,
where apps are often scaled beyond just one replica.

Thankfully, Spin supports configuring an application with an [external SQLite database provider via
runtime
configuration](https://developer.fermyon.com/spin/v2/dynamic-configuration#libsql-storage-provider).
External providers include any [libSQL](https://libsql.org/) databases that can be accessed over
HTTPS.

## Prerequisites

To follow along with this tutorial, you'll need:

- A Kubernetes cluster running SpinKube. See the [Installation]({{< relref "install" >}}) guides for
  more information.
- The [kubectl CLI](https://kubernetes.io/docs/tasks/tools/#kubectl)
- The [spin CLI](https://developer.fermyon.com/spin/v2/install )

## Build and publish the Spin application

For this tutorial, we'll use the [HTTP CRUD Go
SQLite](https://github.com/fermyon/enterprise-architectures-and-patterns/tree/main/http-crud-go-sqlite)
sample application. It is a Go-based app implementing CRUD (Create, Read, Update, Delete) operations
via the SQLite API.

First, clone the repository locally and navigate to the `http-crud-go-sqlite` directory:

```bash
git clone git@github.com:fermyon/enterprise-architectures-and-patterns.git
cd enterprise-architectures-and-patterns/http-crud-go-sqlite
```

Now, build and push the application to a registry you have access to. Here we'll use
[ttl.sh](https://ttl.sh):

```bash
export IMAGE_NAME=ttl.sh/$(uuidgen):1h
spin build
spin registry push ${IMAGE_NAME}
```

## Create a LibSQL database

If you don't already have a LibSQL database that can be used over HTTPS, you can follow along as we
set one up via [Turso](https://turso.tech/).

Before proceeding, install the [turso CLI](https://docs.turso.tech/quickstart) and sign up for an
account, if you haven't done so already.

Create a new database and save its HTTP URL:

```bash
turso db create spinkube
export DB_URL=$(turso db show spinkube --http-url)
```

Next, create an auth token for this database:

```bash
export DB_TOKEN=$(turso db tokens create spinkube)
```

## Create a Kubernetes Secret for the database token

The database token is a sensitive value and thus should be created as a Secret resource in
Kubernetes:

```bash
kubectl create secret generic turso-auth --from-literal=db-token="${DB_TOKEN}"
```

## Prepare the SpinApp manifest

You're now ready to assemble the SpinApp custom resource manifest.

- Note the `image` value uses the reference you published above.
- All of the SQLite database config is set under `spec.runtimeConfig.sqliteDatabases`. See the
  [sqliteDatabases reference guide]({{< ref
  "docs/reference/spin-app#spinappspecruntimeconfigsqlitedatabasesindex" >}}) for more details.
- Here we configure the `default` database to use the `libsql` provider type and under `options`
  supply the database URL and auth token (via its Kubernetes secret)

Plug the `$IMAGE_NAME` and `$DB_URL` values into the manifest below and save as `spinapp.yaml`:

```yaml
apiVersion: core.spinkube.dev/v1alpha1
kind: SpinApp
metadata:
  name: http-crud-go-sqlite
spec:
  image: "$IMAGE_NAME"
  replicas: 1
  executor: containerd-shim-spin
  runtimeConfig:
    sqliteDatabases:
      - name: "default"
        type: "libsql"
        options:
          - name: "url"
            value: "$DB_URL"
          - name: "token"
            valueFrom:
              secretKeyRef:
                name: "turso-auth"
                key: "db-token"
```

## Create the SpinApp

Apply the resource manifest to your Kubernetes cluster:

```bash
kubectl apply -f spinapp.yaml
```

The Spin Operator will handle the creation of the underlying Kubernetes resources on your behalf.

## Test the application

Now you are ready to test the application and verify connectivity and data storage to the configured
SQLite database.

Configure port forwarding from your local machine to the corresponding Kubernetes `Service`:

```bash
kubectl port-forward services/http-crud-go-sqlite 8080:80

Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

When port forwarding is established, you can send HTTP requests to the http-crud-go-sqlite app from
within an additional terminal session. Here are a few examples to get you started.

Get current items:

```bash
$ curl -X GET http://localhost:8080/items
[
  {
    "id": "8b933c84-ee60-45a1-848d-428ad3259e2b",
    "name": "Full Self Driving (FSD)",
    "active": true
  },
  {
    "id": "d660b9b2-0406-46d6-9efe-b40b4cca59fc",
    "name": "Sentry Mode",
    "active": true
  }
]
```

Create a new item:

```bash
$ curl -X POST -d '{"name":"Engage Thrusters","active":true}' localhost:8080/items
{
  "id": "a5efaa73-a4ac-4ffc-9c5c-61c5740e2d9f",
  "name": "Engage Thrusters",
  "active": true
}
```

Get items and see the newly added item:

```bash
$ curl -X GET http://localhost:8080/items
[
  {
    "id": "8b933c84-ee60-45a1-848d-428ad3259e2b",
    "name": "Full Self Driving (FSD)",
    "active": true
  },
  {
    "id": "d660b9b2-0406-46d6-9efe-b40b4cca59fc",
    "name": "Sentry Mode",
    "active": true
  },
  {
    "id": "a5efaa73-a4ac-4ffc-9c5c-61c5740e2d9f",
    "name": "Engage Thrusters",
    "active": true
  }
]
```
