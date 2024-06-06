---
title: Integrating With Rancher Desktop
description: This tutorial shows how to integrate SpinKube and Rancher Desktop
date: 2024-02-16
categories: [Spin Operator]
tags: [Tutorials]
weight: 100
---

[Rancher Desktop](https://rancherdesktop.io/) is an open-source application that provides all the essentials to work with containers and Kubernetes on your desktop.

### Prerequisites

  - An operating system compatible with Rancher Desktop (Windows, macOS, or Linux).
  - Administrative or superuser access on your computer.

### Step 1: Installing Rancher Desktop

  1. **Download Rancher Desktop**:
      - Navigate to the [Rancher Desktop releases page](https://github.com/rancher-sandbox/rancher-desktop/releases/tag/v1.14.0).
      - Select the appropriate installer for your operating system for version 1.14.0.
  2. **Install Rancher Desktop**:
      - Run the downloaded installer and follow the on-screen instructions to complete the installation.

### Step 2: Configure Rancher Desktop

  - Open Rancher Desktop.
  - Navigate to the **Preferences** -> **Kubernetes** menu.
  - Ensure that the **Enable** **Kubernetes** is selected and that the **Enable Traefik** and **Install Spin Operator** Options are checked. Make sure to **Apply** your changes.
  
<img width="1039" alt="Screenshot 2024-06-06 at 15 19 43" src="https://github.com/spinkube/documentation/assets/9831342/655dca70-cd38-491b-84e1-f8e599c107bf">
  
  - Make sure to select `rancher-desktop` from the `Kubernetes Contexts` configuration in your toolbar.
  
![Untitled](https://github.com/spinkube/documentation/assets/9831342/9a841292-acf4-4a4f-bc53-d5327cf7f439)
  
  - Make sure that the Enable Wasm option is checked in the **Preferences** → **Container Engine section**. Remember to always apply your changes.
  
<img width="1088" alt="Screenshot 2024-06-06 at 15 21 21" src="https://github.com/spinkube/documentation/assets/9831342/f0539dc4-3325-4a93-aa50-8b9e260ce99b">
  
  - Once your changes have been applied, go to the **Cluster Dashboard** → **More Resources** → **Cert Manager** section and click on **Certificates**. You will see the `spin-operator-serving-cert` is ready.
  
<img width="1049" alt="Screenshot 2024-06-06 at 15 23 42" src="https://github.com/spinkube/documentation/assets/9831342/28e4674e-7b68-44fc-a18d-f1e16215bf39">

### Step 3: Creating a Spin Application

1. **Open a terminal** (Command Prompt, Terminal, or equivalent based on your OS).
2. **Create a new Spin application**:This command creates a new Spin application using the HTTP-JS template, named `hello-k3s`.

```bash
  $ spin new -t http-js hello-k3s --accept-defaults
  $ cd hello-k3s
```
3. We can edit the `/src/index.js` file and make the workload return a string "Hello from Rancher Desktop":

```javascript
export async function handleRequest(request) {
    return {
        status: 200,
        headers: {"content-type": "text/plain"},
        body: "Hello from Rancher Desktop" // <-- This changed
    }
}
```

### Step 4: Deploying Your Application

1. **Push the application to a registry**:
    
    ```bash
    $ npm install
    $ spin build
    $ spin registry push ttl.sh/hello-k3s:0.1.0
    ```
    
    Replace `ttl.sh/hello-k3s:0.1.0` with your registry URL and tag.
    
2. **Scaffold Kubernetes resources**:
    
    ```bash
    $ spin kube scaffold --from ttl.sh/hello-k3s:0.1.0
    $ spin kube scaffold --from ttl.sh/hello-k3s:0.1.0
    
    apiVersion: core.spinoperator.dev/v1alpha1
    kind: SpinApp
    metadata:
      name: hello-k3s
    spec:
      image: "ttl.sh/hello-k3s:0.1.0"
      executor: containerd-shim-spin
      replicas: 2
    
    ```
    
    This command prepares the necessary Kubernetes deployment configurations.
    
3. **Deploy the application to Kubernetes**:
    
    ```bash
    $ spin kube deploy --from ttl.sh/hello-k3s:0.1.0
    ```
    
    If we click on the Rancher Desktop’s “Cluster Dashboard”, we can see hello-k3s:0.1.0 running inside the “Workloads” dropdown section:
    
    ![Rancher Desktop Preferences Wasm](/rancher-desktop-cluster.png)
    
    To access our app outside of the cluster, we can forward the port so that we access the application from our host machine:
    
    ```bash
    $ kubectl port-forward svc/hello-k3s 8083:80
    ```
    
    To test locally, we can make a request as follows:
    
    ```bash
    $ curl localhost:8083
    ```
    
    The above `curl` command or a quick visit to your browser at locahost:8083 will return the "Hello from Rancher Desktop" message:

   <img width="567" alt="Screenshot 2024-06-06 at 15 52 58" src="https://github.com/spinkube/documentation/assets/9831342/bbdeee26-59a1-4766-b685-e827fce152d1">

    
    ```bash
    Hello from Rancher Desktop
    ```
