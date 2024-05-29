---
title: Contributing
weight: 5
description: >
  Contributing to the Spin Trigger MQTT
categories: [contributing]
tags: [contributing, plugins, mqtt]
---

## Prerequisites

To compile the plugin from source, you will need to:

* Open the repository in a Dev Container or in the pre-configured GitHub [Codespace](https://codespaces.new/spinkube/spin-trigger-mqtt).
* Run `make` to build and install the plugin locally.
* Update `examples/mqtt-app/spin.toml` to reflect your MQTT server details and ensure it's accessible on the network.
* Run `spin build --up --from examples/mqtt-app/spin.toml` to run the example Spin app.
* Run `mqttx pub -t 'messages-in01' -h '<mqtt server ip>' -p 1883 -u <user> -P <password> -m 'Hello to  MQTT Spin Component!'` with the hostname and credentials for your server, to publish the message which is then received by Spin app.
* Optionally, run `make clean` to clean up, rebuild and install the plugin locally.

> See the [Spin Trigger MQTT GitHub repository](https://github.com/spinkube/spin-trigger-mqtt/) for more information.