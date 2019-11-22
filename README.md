crwctl
======

[Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) CLI

[![oclif](https://img.shields.io/badge/cli-oclif-brightgreen.svg)](https://oclif.io)

## Report issues

[Issues are tracked in JIRA](https://issues.jboss.org/browse/CRW-463?jql=project%20%3D%20CRW%20AND%20(component%20%3D%20crwctl%20OR%20labels%20%3D%20crwctl)).

## Table Of Contents

<!-- toc -->
* [Installation](#installation)
* [Usage](#usage)
* [Commands](#commands)
* [Contributing](#contributing)
<!-- tocstop -->
# Installation

There are two channels of `crwctl`: `stable` and `next`

Stable is for all tagged versions of CodeReady Workspaces. Next is updated after each commit to the master branch of the [crwctl repository](https://github.com/redhat-developer/codeready-workspaces-chectl).

Assemblies of crwctl are available at [https://github.com/redhat-developer/codeready-workspaces-chectl/releases](https://github.com/redhat-developer/codeready-workspaces-chectl/releases)

Installation:

1) Download a .tar.gz file based on your Operating System / Arch 
2) Unpack the assembly
3) move `crwctl` folder into a folder like `$HOME/crwctl`
4) add `$HOME/crwctl/bin` to `$PATH``

# Usage
```sh-session
$ crwctl server:start
running command...

$ crwctl server:stop
running command...

$ crwctl workspace:start --devfile
running command...

$ crwctl --help [COMMAND]
USAGE
  $ crwctl COMMAND
...
```
# Commands
<!-- commands -->
* [`crwctl autocomplete [SHELL]`](#crwctl-autocomplete-shell)
* [`crwctl devfile:generate`](#crwctl-devfilegenerate)
* [`crwctl help [COMMAND]`](#crwctl-help-command)
* [`crwctl server:delete`](#crwctl-serverdelete)
* [`crwctl server:start`](#crwctl-serverstart)
* [`crwctl server:stop`](#crwctl-serverstop)
* [`crwctl server:update`](#crwctl-serverupdate)
* [`crwctl workspace:inject`](#crwctl-workspaceinject)
* [`crwctl workspace:list`](#crwctl-workspacelist)
* [`crwctl workspace:start`](#crwctl-workspacestart)
* [`crwctl workspace:stop`](#crwctl-workspacestop)

## `crwctl autocomplete [SHELL]`

display autocomplete installation instructions

```
USAGE
  $ crwctl autocomplete [SHELL]

ARGUMENTS
  SHELL  shell type

OPTIONS
  -r, --refresh-cache  Refresh cache (ignores displaying instructions)

EXAMPLES
  $ crwctl autocomplete
  $ crwctl autocomplete bash
  $ crwctl autocomplete zsh
  $ crwctl autocomplete --refresh-cache
```

_See code: [@oclif/plugin-autocomplete](https://github.com/oclif/plugin-autocomplete/blob/v0.1.4/src/commands/autocomplete/index.ts)_

## `crwctl devfile:generate`

generate and print a devfile to stdout given some Kubernetes resources and other workspaces features (project, language-support, commands etc...)

```
USAGE
  $ crwctl devfile:generate

OPTIONS
  -h, --help                 show CLI help
  --command=command          Command to include in the workspace
  --dockerimage=dockerimage  dockerimage component to include in the Devfile
  --editor=editor            Specify the editor component. Currently supported editors: theia-next,theia-1.0.0
  --git-repo=git-repo        Source code git repository to include in the workspace

  --language=language        Add support for a particular language. Currently supported languages:
                             java,typescript,go,python,c#

  --name=name                Workspace name

  --namespace=namespace      Kubernetes namespace where the resources are defined

  --plugin=plugin            Che plugin to include in the workspace. The format is JSON. For example this is a valid Che
                             Plugin specification: {"type": "TheEndpointName.ChePlugin", "alias": "java-ls", "id":
                             "redhat/java/0.38.0"}

  --selector=selector        label selector to filter the Kubernetes resources. For example
                             --selector="app.kubernetes.io/name=employee-manager"
```

_See code: [src/commands/devfile/generate.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/devfile/generate.ts)_

## `crwctl help [COMMAND]`

display help for crwctl

```
USAGE
  $ crwctl help [COMMAND]

ARGUMENTS
  COMMAND  command to show help for

OPTIONS
  --all  see all commands in CLI
```

_See code: [@oclif/plugin-help](https://github.com/oclif/plugin-help/blob/v2.2.1/src/commands/help.ts)_

## `crwctl server:delete`

delete any CodeReady Workspaces related resource

```
USAGE
  $ crwctl server:delete

OPTIONS
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer
```

_See code: [src/commands/server/delete.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/server/delete.ts)_

## `crwctl server:start`

start CodeReady Workspaces Server

```
USAGE
  $ crwctl server:start

OPTIONS
  -a, --installer=operator                     [default: operator] Installer type

  -b, --domain=domain                          Domain of the Kubernetes cluster (e.g. example.k8s-cluster.com or
                                               <local-ip>.nip.io)

  -h, --help                                   show CLI help

  -i, --cheimage=cheimage                      [default: registry.redhat.io/codeready-workspaces/server-rhel8:2.0]
                                               CodeReady Workspaces server container image

  -m, --multiuser                              Starts CodeReady Workspaces in multi-user mode

  -n, --chenamespace=chenamespace              [default: workspaces] Kubernetes namespace where CodeReady Workspaces
                                               server is supposed to be deployed

  -o, --cheboottimeout=cheboottimeout          (required) [default: 40000] CodeReady Workspaces server bootstrap timeout
                                               (in milliseconds)

  -p, --platform=openshift|crc                 [default: openshift] Type of OpenShift platform. Valid values are
                                               "openshift", "crc (for CodeReady Containers)".

  -s, --tls                                    Enable TLS encryption.
                                               Note that for kubernetes 'che-tls' with TLS
                                               certificate must be created in the configured namespace.
                                               For OpenShift, router will use default cluster
                                               certificates.

  -t, --templates=templates                    [default: templates] Path to the templates folder

  --che-operator-cr-yaml=che-operator-cr-yaml  Path to a yaml file that defines a CheCluster used by the operator. This
                                               parameter is used only when the installer is the operator.

  --che-operator-image=che-operator-image      [default:
                                               registry.redhat.io/codeready-workspaces/server-operator-rhel8:2.0]
                                               Container image of the operator. This parameter is used only when the
                                               installer is the operator

  --deployment-name=deployment-name            [default: codeready] CodeReady Workspaces deployment name

  --devfile-registry-url=devfile-registry-url  The URL of the external Devfile registry.

  --k8spodreadytimeout=k8spodreadytimeout      [default: 130000] Waiting time for Pod Ready Kubernetes (in milliseconds)

  --k8spodwaittimeout=k8spodwaittimeout        [default: 300000] Waiting time for Pod Wait Timeout Kubernetes (in
                                               milliseconds)

  --listr-renderer=default|silent|verbose      [default: default] Listr renderer

  --os-oauth                                   Enable use of OpenShift credentials to log into CodeReady Workspaces

  --plugin-registry-url=plugin-registry-url    The URL of the external plugin registry.

  --self-signed-cert                           Authorize usage of self signed certificates for encryption. Note that
                                               `self-signed-cert` secret with CA certificate must be created in the
                                               configured namespace.
```

_See code: [src/commands/server/start.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/server/start.ts)_

## `crwctl server:stop`

stop CodeReady Workspaces Server

```
USAGE
  $ crwctl server:stop

OPTIONS
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  --access-token=access-token              CodeReady Workspaces OIDC Access Token

  --che-selector=che-selector              [default: app=che,component=che] Selector for CodeReady Workspaces Server
                                           resources

  --deployment-name=deployment-name        [default: codeready] CodeReady Workspaces deployment name

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer
```

_See code: [src/commands/server/stop.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/server/stop.ts)_

## `crwctl server:update`

update CodeReady Workspaces Server

```
USAGE
  $ crwctl server:update

OPTIONS
  -a, --installer=operator                 [default: operator] Installer type
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  -p, --platform=openshift|crc             [default: openshift] Type of Kubernetes platform. Valid values are
                                           "openshift", "crc (for CodeReady Containers)".

  -t, --templates=templates                [default: templates] Path to the templates folder

  --che-operator-image=che-operator-image  [default: registry.redhat.io/codeready-workspaces/server-operator-rhel8:2.0]
                                           Container image of the operator. This parameter is used only when the
                                           installer is the operator

  --deployment-name=deployment-name        [default: codeready] CodeReady Workspaces deployment name

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer

  --skip-version-check                     Skip user confirmation on version check
```

_See code: [src/commands/server/update.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/server/update.ts)_

## `crwctl workspace:inject`

inject configurations and tokens in a workspace

```
USAGE
  $ crwctl workspace:inject

OPTIONS
  -c, --container=container                Target container. If not specified, configuration files will be injected in
                                           all containers of a workspace pod

  -h, --help                               show CLI help

  -k, --kubeconfig                         Inject the local Kubernetes configuration

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  -w, --workspace=workspace                Target workspace. Can be omitted if only one workspace is running

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer
```

_See code: [src/commands/workspace/inject.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/workspace/inject.ts)_

## `crwctl workspace:list`

list workspaces

```
USAGE
  $ crwctl workspace:list

OPTIONS
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  --access-token=access-token              CodeReady Workspaces OIDC Access Token

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer
```

_See code: [src/commands/workspace/list.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/workspace/list.ts)_

## `crwctl workspace:start`

create and start a workspace

```
USAGE
  $ crwctl workspace:start

OPTIONS
  -f, --devfile=devfile                    path or URL to a valid devfile
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  -w, --workspaceconfig=workspaceconfig    path to a valid workspace configuration json file

  --access-token=access-token              CodeReady Workspaces OIDC Access Token

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer

  --name=name                              workspace name: overrides the workspace name to use instead of the one
                                           defined in the devfile. Works only for devfile
```

_See code: [src/commands/workspace/start.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/workspace/start.ts)_

## `crwctl workspace:stop`

stop a running workspace

```
USAGE
  $ crwctl workspace:stop

OPTIONS
  -h, --help                               show CLI help

  -n, --chenamespace=chenamespace          [default: workspaces] Kubernetes namespace where CodeReady Workspaces server
                                           is supposed to be deployed

  --access-token=access-token              CodeReady Workspaces OIDC Access Token

  --listr-renderer=default|silent|verbose  [default: default] Listr renderer
```

_See code: [src/commands/workspace/stop.ts](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/v2.0.0/src/commands/workspace/stop.ts)_
<!-- commandsstop -->

# Contributing

Contributing to crwctl is covered in [CONTRIBUTING.md](https://github.com/redhat-developer/codeready-workspaces-chectl/blob/master/CONTRIBUTING.md)
