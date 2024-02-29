---
title: CLI Reference
description: Spin Plugin k8s CLI Reference
weight: 100
categories: [reference]
tags: [plugins]
---

## spin k8s completion

```bash
spin k8s completion --help
Generate the autocompletion script for k8s for the specified shell.
See each sub-command's help for details on how to use the generated script.

Usage:
  k8s completion [command]

Available Commands:
  bash        Generate the autocompletion script for bash
  fish        Generate the autocompletion script for fish
  powershell  Generate the autocompletion script for powershell
  zsh         Generate the autocompletion script for zsh

Flags:
  -h, --help   help for completion
```

### spin k8s completion bash

```bash
spin k8s completion bash --help
Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(k8s completion bash)

To load completions for every new session, execute once:

#### Linux:

	k8s completion bash > /etc/bash_completion.d/k8s

#### macOS:

	k8s completion bash > $(brew --prefix)/etc/bash_completion.d/k8s

You will need to start a new shell for this setup to take effect.

Usage:
  k8s completion bash

Flags:
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### spin k8s completion fish

```bash
spin k8s completion fish --help
Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	k8s completion fish | source

To load completions for every new session, execute once:

	k8s completion fish > ~/.config/fish/completions/k8s.fish

You will need to start a new shell for this setup to take effect.

Usage:
  k8s completion fish [flags]

Flags:
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions
```

### spin k8s completion powershell

```bash
spin k8s completion powershell --help
Generate the autocompletion script for powershell.

To load completions in your current shell session:

	k8s completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.

Usage:
  k8s completion powershell [flags]

Flags:
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions
```

### spin k8s completion zsh

```bash
spin k8s completion zsh --help       
Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(k8s completion zsh)

To load completions for every new session, execute once:

#### Linux:

	k8s completion zsh > "${fpath[1]}/_k8s"

#### macOS:

	k8s completion zsh > $(brew --prefix)/share/zsh/site-functions/_k8s

You will need to start a new shell for this setup to take effect.

Usage:
  k8s completion zsh [flags]

Flags:
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions
```

## spin k8s help

```bash
spin k8s --help
Manage apps running on Kubernetes

Usage:
  k8s [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  scaffold    scaffold SpinApp manifest
  version     Display version information

Flags:
  -h, --help                help for k8s
      --kubeconfig string   the path to the kubeconfig file
  -n, --namespace string    the namespace scope
  -v, --version             version for k8s
```

## spin k8s scaffold

```bash
spin k8s scaffold --help
scaffold SpinApp manifest

Usage:
  k8s scaffold [flags]

Flags:
      --autoscaler string                            The autoscaler to use. Valid values are 'hpa' and 'keda'
      --autoscaler-target-cpu-utilization int32      The target CPU utilization percentage to maintain across all pods (default 60)
      --autoscaler-target-memory-utilization int32   The target memory utilization percentage to maintain across all pods (default 60)
      --cpu-limit string                             The maximum amount of CPU resource units the Spin application is allowed to use
      --cpu-request string                           The amount of CPU resource units requested by the Spin application. Used to determine which node the Spin application will run on
      --executor string                              The executor used to run the Spin application (default "containerd-shim-spin")
  -f, --from string                                  Reference in the registry of the Spin application
  -h, --help                                         help for scaffold
  -s, --image-pull-secret strings                    secrets in the same namespace to use for pulling the image
      --max-replicas int32                           Maximum number of replicas for the spin app. Autoscaling must be enabled to use this flag (default 3)
      --memory-limit string                          The maximum amount of memory the Spin application is allowed to use
      --memory-request string                        The amount of memory requested by the Spin application. Used to determine which node the Spin application will run on
  -o, --out string                                   path to file to write manifest yaml
  -r, --replicas int32                               Minimum number of replicas for the spin app (default 2)
  -c, --runtime-config-file string                   path to runtime config file
```

## spin k8s version

```bash
spin k8s version
```
