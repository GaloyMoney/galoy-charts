#!/bin/bash

# Bumps `tunnelConnector.image.digest` in `charts/galoy-deps/values.yaml`
# to the digest of the currently-latest `tunnel-connector:edge` image, as
# fetched by the `tunnel-connector-image` registry resource. Pairs with
# `open-bump-tunnel-connector-image-pr.sh`, which opens/updates the PR.
#
# No-op (no commit) when the digest in values.yaml already matches —
# otherwise Concourse would churn a PR on every resource poll.

set -eu

DIGEST=$(cat tunnel-connector-image/digest)
VALUES="charts-repo/charts/galoy-deps/values.yaml"

CURRENT=$(yq '.tunnelConnector.image.digest' "$VALUES")
if [[ "$CURRENT" == "$DIGEST" ]]; then
  echo "tunnel-connector digest already at $DIGEST — nothing to do"
  exit 0
fi

yq -i ".tunnelConnector.image.digest = \"${DIGEST}\"" "$VALUES"

if [[ -z $(git config --global user.email) ]]; then
  git config --global user.email "bot@galoy.io"
fi
if [[ -z $(git config --global user.name) ]]; then
  git config --global user.name "CI Bot"
fi

cd charts-repo
git add -A
git status

if ! git diff --cached --exit-code; then
  git commit -m "chore(deps): bump tunnel-connector image digest to ${DIGEST}"
fi
