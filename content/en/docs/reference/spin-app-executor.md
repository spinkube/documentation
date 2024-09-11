---
title: SpinAppExecutor
weight: 2
description: Custom Resource Definition (CRD) reference for `SpinAppExecutor`.
categories: [Spin Operator]
tags: [reference]
aliases:
- /docs/spin-operator/reference/spin-app-executor
---
Resource Types:

- [SpinAppExecutor](#spinappexecutor)

## SpinAppExecutor

SpinAppExecutor is the Schema for the spinappexecutors API

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
      <td><b>apiVersion</b></td>
      <td>string</td>
      <td>core.spinoperator.dev/v1alpha1</td>
      <td>true</td>
      </tr>
      <tr>
      <td><b>kind</b></td>
      <td>string</td>
      <td>SpinAppExecutor</td>
      <td>true</td>
      </tr>
      <tr>
      <td><b><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#objectmeta-v1-meta">metadata</a></b></td>
      <td>object</td>
      <td>Refer to the Kubernetes API documentation for the fields of the `metadata` field.</td>
      <td>true</td>
      </tr><tr>
        <td><b><a href="#spinappexecutorspec">spec</a></b></td>
        <td>object</td>
        <td>
          SpinAppExecutorSpec defines the desired state of SpinAppExecutor<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>status</b></td>
        <td>object</td>
        <td>
          SpinAppExecutorStatus defines the observed state of SpinAppExecutor<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>


### `SpinAppExecutor.spec`
<small>[back to parent](#spinappexecutor)</small>


SpinAppExecutorSpec defines the desired state of SpinAppExecutor

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>createDeployment</b></td>
        <td>boolean</td>
        <td>
          CreateDeployment specifies whether the Executor wants the SpinKube operator
to create a deployment for the application or if it will be realized externally.<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b><a href="#spinappexecutorspecdeploymentconfig">deploymentConfig</a></b></td>
        <td>object</td>
        <td>
          DeploymentConfig specifies how the deployment should be configured when
createDeployment is true.<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>


### `SpinAppExecutor.spec.deploymentConfig`
<small>[back to parent](#spinappexecutorspec)</small>


DeploymentConfig specifies how the deployment should be configured when
createDeployment is true.

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>runtimeClassName</b></td>
        <td>string</td>
        <td>
          RuntimeClassName is the runtime class name that should be used by pods created
as part of a deployment.<br/>
        </td>
        <td>true</td>
      </tr><tr>
        <td><b>caCertSecret</b></td>
        <td>string</td>
        <td>
          CACertSecret specifies the name of the secret containing the CA
certificates to be mounted to the deployment.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>installDefaultCACerts</b></td>
        <td>boolean</td>
        <td>
          InstallDefaultCACerts specifies whether the default CA
certificate bundle should be generated. When set a new secret
will be created containing the certificates. If no secret name is
defined in `CACertSecret` the secret name will be `spin-ca`.<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b><a href="#spinappexecutorspecdeploymentconfigotel">otel</a></b></td>
        <td>object</td>
        <td>
          Otel provides Kubernetes Bindings to Otel Variables.<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>

### `SpinAppExecutor.spec.deploymentConfig.otel`

<small>[back to parent](#spinappexecutorspecdeploymentconfig)</small>

Otel provides Kubernetes Bindings to Otel Variables.

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Required</th>
        </tr>
    </thead>
    <tbody><tr>
        <td><b>exporter_otlp_endpoint</b></td>
        <td>string</td>
        <td>
          ExporterOtlpEndpoint configures the default combined otlp endpoint for sending telemetry<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>exporter_otlp_logs_endpoint</b></td>
        <td>string</td>
        <td>
          ExporterOtlpLogsEndpoint configures the logs-specific otlp endpoint<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>exporter_otlp_metrics_endpoint</b></td>
        <td>string</td>
        <td>
          ExporterOtlpMetricsEndpoint configures the metrics-specific otlp endpoint<br/>
        </td>
        <td>false</td>
      </tr><tr>
        <td><b>exporter_otlp_traces_endpoint</b></td>
        <td>string</td>
        <td>
          ExporterOtlpTracesEndpoint configures the trace-specific otlp endpoint<br/>
        </td>
        <td>false</td>
      </tr></tbody>
</table>
