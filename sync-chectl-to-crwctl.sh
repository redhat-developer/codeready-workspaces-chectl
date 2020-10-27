#!/bin/bash
#
# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#
# convert chectl upstream to downstream using sed & perl transforms, and deleting files

set -e

if [[ $# -lt 3 ]]; then
	echo "Usage:   $0 SOURCEDIR TARGETDIR CRW_SERVER_TAG CRW_OPERATOR_TAG"
	echo "Example: $0 /path/to/chectl /path/to/crwctl 2.1-20 2.1-19"
	echo ""
	echo "Note: CRW_*_TAG = default image tags (eg., server-rhel8:2.1-20 and crw-2-rhel8-operator:2.1-19)"
	exit 1
fi

SOURCEDIR=$1; SOURCEDIR=${SOURCEDIR%/}
TARGETDIR=$2; TARGETDIR=${TARGETDIR%/}
CRW_SERVER_TAG="$3"   # eg., 2.1-20 as in server-rhel8:2.1-20 to set as default
CRW_OPERATOR_TAG="$4" # eg., 2.1-19 as in crw-2-rhel8-operator:2.1-19 to set as default

# global / generic changes
pushd "${SOURCEDIR}" >/dev/null
	while IFS= read -r -d '' d; do
		echo "Convert ${d}"
		if [[ -d "${SOURCEDIR}/${d%/*}" ]]; then mkdir -p "${TARGETDIR}"/"${d%/*}"; fi
		sed -r \
			-e "s|route_names = \['che'|route_names = \['codeready'|g" \
			-e "s|https://github.com/che-incubator/chectl|https://github.com/redhat-developer/codeready-workspaces-chectl|g" \
			-e "s|chectl|crwctl|g" \
			-e "s|crwctl-generated|chectl-generated|g" \
			-e "s|labelSelector=app%3Dche|labelSelector=app%3Dcodeready|g" \
			\
			-e "s|/codeready-workspaces-crwctl|/codeready-workspaces-chectl|g" \
			-e "s|app=che|app=codeready|g" \
			-e "s|app=codeready,component=che|app=codeready,component=codeready|" \
			-e "s|che-operator|codeready-operator|g" \
			-e "s| && isStableVersion\(flags\)||g" \
			-e "s|, isStableVersion||g" \
			-e "s|/codeready-operator/|/codeready-workspaces-operator/|g" \
			\
			-e "s|codeready-operator-(cr.+yaml)|che-operator-\1|g" \
			-e "s|codeready-operator-(cr.+yaml)|che-operator-\1|g" \
			-e "s|codeready-operator-image|che-operator-image|g" \
			-e "s|CHE_CLUSTER_CR_NAME = 'eclipse-che'|CHE_CLUSTER_CR_NAME = 'codeready-workspaces'|g" \
			-e "s|Eclipse Che|CodeReady Workspaces|g" \
			\
			-e "s| when both minishift and OpenShift are stopped||" \
			-e "s|resource: Kubernetes/OpenShift/Helm|resource|g" \
			-e "/import \{ HelmTasks \} from '..\/..\/tasks\/installers\/helm'/d" \
			-e "/import \{ MinishiftAddonTasks \} from '..\/..\/tasks\/installers\/minishift-addon'/d" \
			-e "/    const helmTasks = new HelmTasks\(flags\)/d" \
			-e "/    const (minishiftAddonTasks|msAddonTasks) = new MinishiftAddonTasks\(\)/d" \
			-e '/.+tasks.add\(helmTasks.+/d' \
			-e '/.+tasks.add\((minishiftAddonTasks|msAddonTasks).+/d' \
			-e "s|(const DEFAULT_CHE_IMAGE =).+|\1 'registry.redhat.io/codeready-workspaces/server-rhel8:${CRW_SERVER_TAG}'|g" \
			-e "s|(const DEFAULT_CHE_OPERATOR_IMAGE =).+|\1 'registry.redhat.io/codeready-workspaces/crw-2-rhel8-operator:${CRW_OPERATOR_TAG}'|g" \
			\
			-e "s|(const CHE_CLUSTER_CR_NAME =).+|\1 'codeready-workspaces'|g" \
			\
			-e "s|(const DEFAULT_CHE_OLM_PACKAGE_NAME =).+|\1 'codeready-workspaces'|g" \
			-e "s|(const OLM_STABLE_CHANNEL_NAME =).+|\1 'latest'|g" \
			-e "s|(const CUSTOM_CATALOG_SOURCE_NAME =).+|\1 'codeready-custom-catalog-source'|g" \
			-e "s|(const SUBSCRIPTION_NAME =).+|\1 'codeready-subscription'|g" \
			-e "s|(const OPERATOR_GROUP_NAME =).+|\1 'codeready-operator-group'|g" \
			-e "s|(const OPENSHIFT_OLM_CATALOG =).+|\1 'redhat-operators'|g" \
			-e "s|(CVS_PREFIX =).+|\1 'crwoperator'|g" \
			\
			-e "s|\"CodeReady Workspaces will be deployed in Multi-User mode.+mode.\"|'CodeReady Workspaces can only be deployed in Multi-User mode.'|" \
			-e "s|che-incubator/crwctl|redhat-developer/codeready-workspaces-chectl|g" \
		"$d" > "${TARGETDIR}/${d}"
	done <   <(find src test -type f -name "*" -print0)
	# TODO add package.json into the above?
popd >/dev/null

# Remove workspace commands
pushd "${TARGETDIR}" >/dev/null
    while IFS= read -r -d '' d; do
        echo "[INFO] Delete ${d#./}"
        rm -f "$d"
        #
    done <   <(find . -regextype posix-extended -iregex '.+/(inject|create|delete|list|logs|start|stop).ts' -print0)
popd >/dev/null


# Remove files
pushd "${TARGETDIR}" >/dev/null
	while IFS= read -r -d '' d; do
		echo "Delete ${d#./}"
		rm -f "$d"
		#
	done <   <(find . -regextype posix-extended -iregex '.+/(helm|minishift|minishift-addon|minikube|microk8s|k8s|docker-desktop)(.test|).ts' -print0)
popd >/dev/null

# per-file changes:
platformString="    platform: string({\n\
      char: 'p',\n\
      description: 'Type of OpenShift platform. Valid values are \\\\\"openshift\\\\\", \\\\\"crc (for CodeReady Containers)\\\\\".',\n\
      options: ['openshift', 'crc'],\n\
      default: 'openshift'\n\
    }),"; # echo -e "$platformString"
installerString="    installer: string({\n\
      char: 'a',\n\
      description: 'Installer type. If not set, default is "olm" for OpenShift >= 4.2, and "operator" for earlier versions.',\n\
      options: ['olm', 'operator']\n\
    }),"; # echo -e "$installerString"
pushd "${TARGETDIR}" >/dev/null
	for d in src/commands/server/update.ts src/commands/server/start.ts; do
		echo "Convert ${d}"
		mkdir -p "${TARGETDIR}/${d%/*}"
		perl -0777 -p -i -e 's|(\ +platform: string\({.*?}\),)| ${1} =~ /.+minishift.+/?"INSERT-CONTENT-HERE":${1}|gse' "${TARGETDIR}/${d}"
		sed -r -e "s#INSERT-CONTENT-HERE#${platformString}#" -i "${TARGETDIR}/${d}"

		perl -0777 -p -i -e 's|(\ +installer: string\({.*?}\),)| ${1} =~ /.+minishift.+/?"INSERT-CONTENT-HERE":${1}|gse' "${TARGETDIR}/${d}"
		sed -r -e "s#INSERT-CONTENT-HERE#${installerString}#" -i "${TARGETDIR}/${d}"
	done
popd >/dev/null

pushd "${TARGETDIR}" >/dev/null
	d=src/common-flags.ts
	echo "Convert ${d}"
	mkdir -p "${TARGETDIR}/${d%/*}"
	sed -r \
		`# replace line after specified one with new default` \
		-e "/description: 'Kubernetes namespace/{n;s/.+/  default: 'workspaces',/}" \
		-e "/description: .+ deployment name.+/{n;s/.+/  default: 'codeready',/}" \
		-i "${TARGETDIR}/${d}"
popd >/dev/null

operatorTasksString="export class OperatorTasks {\n\
  operatorServiceAccount = 'codeready-operator'\n\
  operatorRole = 'codeready-operator'\n\
  operatorClusterRole = 'codeready-operator'\n\
  operatorRoleBinding = 'codeready-operator'\n\
  operatorClusterRoleBinding = 'codeready-operator'\n\
  cheClusterCrd = 'checlusters.org.eclipse.che'\n\
  operatorName = 'codeready-operator'\n\
  operatorCheCluster = 'codeready-workspaces'\n\
  resourcesPath = ''"
pushd "${TARGETDIR}" >/dev/null
	d=src/tasks/installers/operator.ts
	echo "Convert ${d}"
	mkdir -p "${TARGETDIR}/${d%/*}"
	perl -0777 -p -i -e 's|(export class OperatorTasks.*?  resourcesPath = )|  ${1} =~ /.+che-operator.+/?"INSERT-CONTENT-HERE":${1}|gse' "${TARGETDIR}/${d}"
	sed -r -e "s#INSERT-CONTENT-HERE.+#${operatorTasksString}#" -i "${TARGETDIR}/${d}"
popd >/dev/null

# remove if blocks
pushd "${TARGETDIR}" >/dev/null
	for d in src/tasks/installers/installer.ts src/tasks/platforms/platform.ts; do
		echo "Convert ${d}"
		mkdir -p "${TARGETDIR}/${d%/*}"
		sed -i -r -e '/.+BEGIN CHE ONLY$/,/.+END CHE ONLY$/d' "${TARGETDIR}/${d}"
		sed -r -e "/.*(import|const).+(Helm|Minishift|DockerDesktop|K8s|MicroK8s|Minikube).*Tasks.*/d" -i "${TARGETDIR}/${d}"
	done
popd >/dev/null

# TODO implement changes for converting package.json from chectl to crwclt
# pushd "${TARGETDIR}" >/dev/null
# 	d=package.json
# 	echo "Convert ${d}"
# 	sed -r  \
# 			-e "s|che-operator|codeready-workspaces-operator|g" \
# 		-i "${TARGETDIR}/${d}"
# popd >/dev/null
