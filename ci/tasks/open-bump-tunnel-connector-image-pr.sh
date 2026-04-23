#!/bin/bash

# Opens (or re-opens) a PR for the bot-branch that
# `bump-tunnel-connector-image.sh` force-pushes to. Closes any existing
# PR on that branch first so the body reflects the current digest — the
# branch is continuously force-pushed, and we want a single, always-current
# open PR rather than a list of stale superseded ones.

set -eu

pushd charts-repo > /dev/null

DIGEST=$(yq '.tunnelConnector.image.digest' charts/galoy-deps/values.yaml)

cat <<EOF > ../body.md
Auto-bump of \`tunnelConnector.image.digest\` in \`charts/galoy-deps/values.yaml\` to the latest \`tunnel-connector:edge\` digest published by drua CI:

\`\`\`
${DIGEST}
\`\`\`

This pins galoy-deps to a specific image content hash, so a subsequent CI push to drua can't silently roll a running connector. The bot force-pushes the bot branch on every new drua image, so this PR is always current — merge when convenient.
EOF

export GH_TOKEN="$(ghtoken generate -b "${GH_APP_PRIVATE_KEY}" -i "${GH_APP_ID}" | jq -r '.token')"

gh pr close "${BOT_BRANCH}" || true
gh pr create \
  --title "chore(deps): bump tunnel-connector image digest" \
  --body-file ../body.md \
  --base "${BRANCH}" \
  --head "${BOT_BRANCH}" \
  --label galoybot \
  --label tunnel-connector

popd > /dev/null
