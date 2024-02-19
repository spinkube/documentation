---
title: Share Spin Operator Image
description: How to build and push the Spin Operator image
date: 2024-02-16
categories: [Spin Operator]
tags: [Common Tasks]
---

You can build and push the Spin Operator image using the `docker-build` and `docker-push` targets specified in the `Makefile`.

 * The `docker-build` task invokes local `docker` tooling and builds a Docker image matching your local system architecture. 
 * The `docker-push` task invokes local `docker` tooling and pushes the Docker image to a container registry.

You can chain both targets using `make docker-build docker-push` to perform build and push at once. 

Ensure to provide the fully qualified image name as `IMG` argument to push your custom Spin Operator image to the desired container registry:

```shell
# Build & Push a custom Spin Operator Image
make docker-build docker-push IMG=<some-registry>/spin-operator:tag
```

> This image ought to be published in the personal registry you specified. And it is required to have access to pull the image from the working environment. Make sure you have the proper permission to the registry if the above command doesn't work.
