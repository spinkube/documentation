---
title: Installation
description: Learn how to install the Spin Trigger MQTT
weight: 1
categories: [guides]
tags: [plugins, MQTT, spin]
---

## Installing Spin

If you haven’t already, please go ahead and [install the latest version of Spin](https://developer.fermyon.com/spin/install).

> Upgrading Spin: If you have an older version of Spin, please see the Spin [upgrade](https://developer.fermyon.com/spin/v2/upgrade) page.
> 

## Install Plugin

Install MQTT Plugin:

```bash
$ spin plugin install --url https://raw.githubusercontent.com/spinkube/spin-trigger-mqtt/main/trigger-mqtt-remote.json --yes

```

[Note: release management for multiple versions of this plugin/trigger will be added soon]

## Install Template

[Spin templates](https://www.fermyon.com/blog/managing-spin-templates-and-plugins) allow a Spin developer to quickly create the skeleton of an application or component, ready for the application logic to be filled in. As part of this repo, a new template is created to help build applications which make use of MQTT as a communication protocol/trigger.

Install MQTT Template:

```bash
$ spin templates install --git https://github.com/spinkube/spin-trigger-mqtt --upgrade

```

## Create Spin App

Below is a simple example where we create a new app and pass in some credentials like `user` and `password`, `topic` and so on: 

```
$ spin new -t mqtt-rust mqtt-app
Description: Demo app to receive MQTT messages.
Mqtt Address: mqtt://localhost:1883
Mqtt Username: user
Mqtt Password: password
Mqtt Keep Alive Interval (Secs between 0-65535): 30
Mqtt Topic: topic
Mqtt QoS for Topic (between 0-2): 1
```

The `address`, `username`, `password` and `topic` support the ability to be configured using Spin variables which would be a better solution but is out of scope for this article. Please see the [adding variables to your application](https://developer.fermyon.com/spin/v2/variables#adding-variables-to-your-applications) section of the developer documentation for more information.

The application manifest will look similar to the following:

```
spin_manifest_version = "1"
authors = ["Fermyon Engineering <engineering@fermyon.com>"]
description = "Demo app to receive MQTT messages."
name = "mqtt-app"
trigger = { type = "mqtt", address = "mqtt://localhost:1883", username = "user", password = "password", keep_alive_interval = "30" }
version = "0.1.0"

[[component]]
id = "mqtt-app"
source = "target/wasm32-wasi/release/mqtt_app.wasm"
allowed_outbound_hosts = ["mqtt://localhost:1883"]
[component.trigger]
topic = "topic"
qos = "1"
[component.build]
command = "cargo build --target wasm32-wasi --release"

```

To build the application we use the `spin build` command:

```bash
$ spin build
```