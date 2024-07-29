---
title: Connecting to your app
description: Learn how to connect to your application.
weight: 13
---

This topic guide shows you how to connect to your application deployed to SpinKube, including how to
use port-forwarding for local development, or Ingress rules for a production setup.

## Run the sample application

Let's deploy a sample application to your Kubernetes cluster. We will use this application
throughout the tutorial to demonstrate how to connect to it.

Refer to the [quickstart guide]({{< ref "quickstart" >}}) if you haven't set up a Kubernetes cluster
yet.

```shell
kubectl apply -f https://raw.githubusercontent.com/spinkube/spin-operator/main/config/samples/simple.yaml
```

When SpinKube deploys the application, it creates a Kubernetes Service that exposes the application
to the cluster. You can check the status of the deployment with the following command:

```shell
kubectl get services
```

You should see a service named `simple-spinapp` with a type of `ClusterIP`. This means that the
service is only accessible from within the cluster.

```shell
NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
simple-spinapp   ClusterIP   10.43.152.184    <none>        80/TCP    1m
```

We will use this service to connect to your application.

## Port forwarding

This option is useful for debugging and development. It allows you to forward a local port to the
service.

Forward port 8083 to the service so that it can be reached from your computer:

```shell
kubectl port-forward svc/simple-spinapp 8083:80
```

You should be able to reach it from your browser at [http://localhost:8083](http://localhost:8083):

```shell
curl http://localhost:8083
```

You should see a message like "Hello world from Spin!".

This is one of the simplest ways to test your application. However, it is not suitable for
production use. The next section will show you how to expose your application to the internet using
an Ingress controller.

## Ingress

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster.
Traffic routing is controlled by rules defined on the Ingress resource.

Here is a simple example where an Ingress sends all its traffic to one Service:

![Ingress](../ingress.svg)

(source: [Kubernetes
documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/))

An Ingress may be configured to give applications externally-reachable URLs, load balance traffic,
terminate SSL / TLS, and offer name-based virtual hosting. An Ingress controller is responsible for
fulfilling the Ingress, usually with a load balancer, though it may also configure your edge router
or additional frontends to help handle the traffic.

### Prerequisites

You must have an [Ingress
controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) to satisfy
an Ingress rule. Creating an Ingress rule without a controller has no effect.

Ideally, all Ingress controllers should fit the reference specification. In reality, the various
Ingress controllers operate slightly differently. Make sure you review your Ingress controller's
documentation to understand the specifics of how it works.

[ingress-nginx](https://kubernetes.github.io/ingress-nginx/deploy/) is a popular Ingress controller,
so we will use it in this tutorial:

```shell
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Wait for the ingress controller to be ready:

```shell
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

### Check the Ingress controller's external IP address

If your Kubernetes cluster is a "real" cluster that supports services of type `LoadBalancer`, it
will have allocated an external IP address or FQDN to the ingress controller.

Check the IP address or FQDN with the following command:

```shell
kubectl get service ingress-nginx-controller --namespace=ingress-nginx
```

It will be the `EXTERNAL-IP` field. If that field shows `<pending>`, this means that your Kubernetes
cluster wasn't able to provision the load balancer. Generally, this is because it doesn't support
services of type `LoadBalancer`.

Once you have the external IP address (or FQDN), set up a DNS record pointing to it. Refer to your
DNS provider's documentation on how to add a new DNS record to your domain.

You will want to create an A record that points to the external IP address. If your external IP
address is `<EXTERNAL-IP>`, you would create a record like this:

```shell
A    myapp.spinkube.local    <EXTERNAL-IP>
```

Once you've added a DNS record to your domain and it has propagated, proceed to create an ingress
resource.

### Create an Ingress resource

Create an Ingress resource that routes traffic to the `simple-spinapp` service. The following
example assumes that you have set up a DNS record for `myapp.spinkube.local`:

```shell
kubectl create ingress simple-spinapp --class=nginx --rule="myapp.spinkube.local/*=simple-spinapp:80"
```

A couple notes about the above command:

- `simple-spinapp` is the name of the Ingress resource.
- `myapp.spinkube.local` is the hostname that the Ingress will route traffic to. This is the DNS
  record you set up earlier.
- `simple-spinapp:80` is the Service that SpinKube created for us. The application listens for
  requests on port 80.

Assuming DNS has propagated correctly, you should see a message like "Hello world from Spin!" when
you connect to http://myapp.spinkube.local/.

Congratulations, you are serving a public website hosted on a Kubernetes cluster! 🎉

### Connecting with kubectl port-forward

This is a quick way to test your Ingress setup without setting up DNS records or on clusters without
support for services of type `LoadBalancer`.

Open a new terminal and forward a port from localhost port 8080 to the Ingress controller:

```shell
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80
```

Then, in another terminal, test the Ingress setup:

```shell
curl --resolve myapp.spinkube.local:8080:127.0.0.1 http://myapp.spinkube.local:8080/hello
```

You should see a message like "Hello world from Spin!".

If you want to see your app running in the browser, update your `/etc/hosts` file to resolve
requests from `myapp.spinkube.local` to the ingress controller:

```shell
127.0.0.1       myapp.spinkube.local
```
