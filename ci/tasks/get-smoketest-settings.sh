#!/bin/bash

set -euo pipefail

mkdir -p .kube
export KUBECONFIG=$(pwd)/.kube/config
printf '%s' "${SMOKETEST_KUBECONFIG}" | base64 --decode > "${KUBECONFIG}"

secret_name="${SMOKETEST_SECRET:-$(cat testflight/env_name)}"

kubectl get secret "${secret_name}" -o json \
  | jq -r '.data' > "${OUT}/data.json"

cat <<EOF > "${OUT}/helpers.sh"
function setting() {
  cat smoketest-settings/data.json | jq -r ".\$1" | base64 --decode
}
function setting_exists() {
  cat smoketest-settings/data.json | jq -r ".\$1 // null"
}
EOF
