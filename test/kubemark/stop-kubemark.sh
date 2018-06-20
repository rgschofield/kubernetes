#!/usr/bin/env bash

# Copyright 2015 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Script that destroys Kubemark cluster and deletes all master resources.

KUBE_ROOT=$(dirname "${BASH_SOURCE}")/../..

function cloud-provider-stop {
  echo -n -e "Which cloud provider do you wish to use? [iks/gce]${color_cyan}>${color_norm} "
  read CLOUD_PROVIDER
  if [ "${CLOUD_PROVIDER}" = "iks" ]; then
    echo -e "${color_yellow}CLOUD PROVIDER SET: IKS${color_norm}"
    KUBECTL=kubectl
    source "${KUBE_ROOT}/test/kubemark/${CLOUD_PROVIDER}/util.sh"
	  source "${KUBE_ROOT}/cluster/kubemark/${CLOUD_PROVIDER}/config-default.sh"

	  # Login to cloud services
	  complete-login

	  # Delete clusters
	  delete-clusters
	  bash ${RESOURCE_DIRECTORY}/iks-namespacelist.sh
	  rm -f ${RESOURCE_DIRECTORY}/iks-namespacelist.sh
	  spawn-config

  elif [ "${CLOUD_PROVIDER}" = "gce" ]; then
    echo -e "${color_yellow}CLOUD PROVIDER SET: GCE${color_norm}"
    source "${KUBE_ROOT}/test/kubemark/skeleton/util.sh"
    source "${KUBE_ROOT}/test/kubemark/${CLOUD_PROVIDER}/util.sh"
	  source "${KUBE_ROOT}/cluster/kubemark/${CLOUD_PROVIDER}/config-default.sh"
    source "${KUBE_ROOT}/test/kubemark/cloud-provider-config.sh"
    source "${KUBE_ROOT}/cluster/kubemark/util.sh"
    KUBECTL="${KUBE_ROOT}/cluster/kubectl.sh"
    
    detect-project &> /dev/null
  else
    echo -e "${color_red}Invalid response, please try again:${color_norm}"
    cloud-provider-stop
  fi
}

KUBEMARK_DIRECTORY="${KUBE_ROOT}/test/kubemark"
RESOURCE_DIRECTORY="${KUBEMARK_DIRECTORY}/resources"

cloud-provider-stop

"${KUBECTL}" delete -f "${RESOURCE_DIRECTORY}/addons" &> /dev/null || true
"${KUBECTL}" delete -f "${RESOURCE_DIRECTORY}/hollow-node.yaml" &> /dev/null || true
"${KUBECTL}" delete -f "${RESOURCE_DIRECTORY}/kubemark-ns.json" &> /dev/null || true

rm -rf "${RESOURCE_DIRECTORY}/addons" \
	"${RESOURCE_DIRECTORY}/kubeconfig.kubemark" \
	"${RESOURCE_DIRECTORY}/hollow-node.yaml" \
	"${RESOURCE_DIRECTORY}/kubemark-master-env.sh"  &> /dev/null || true

if [ "${CLOUD_PROVIDER}" = "gce" ]; then
  delete-master-instance-and-resources
fi

echo -e "${color_yellow}EXECUTION COMPLETE${color_norm}"
