#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused jq nix-prefetch-git curl
# shellcheck shell=bash

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "rpcs3" || ! -f "$ROOT/default.nix" ]]; then
    echo "ERROR: Not in the rpcs3 folder"
    exit 1
fi

if [[ ! -v GITHUB_TOKEN ]]; then
    echo "ERROR: \$GITHUB_TOKEN not set"
    exit 1
fi

PAYLOAD=$(jq -cn --rawfile query /dev/stdin '{"query": $query}' <<EOF | curl -s -H "Authorization: bearer $GITHUB_TOKEN" -d '@-' https://api.github.com/graphql
{
  repository(owner: "RPCS3", name: "rpcs3") {
    branch: ref(qualifiedName: "refs/heads/master") {
      target {
        oid
        ... on Commit {
          history {
            totalCount
          }
        }
      }
    }

    tag: refs(refPrefix: "refs/tags/", first: 1, orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {
      nodes {
        name
      }
    }
  }
}
EOF
)
RPCS3_COMMIT=$(jq -r .data.repository.branch.target.oid <<< "$PAYLOAD")
RPCS3_MAJORVER=$(jq -r .data.repository.tag.nodes[0].name <<< "$PAYLOAD" | sed 's/^v//g')
RPCS3_COUNT=$(jq -r .data.repository.branch.target.history.totalCount <<< "$PAYLOAD")

RPCS3_GITVER="$RPCS3_COUNT-${RPCS3_COMMIT::9}"
echo "INFO: Latest commit is $RPCS3_COMMIT"
echo "INFO: Latest version is $RPCS3_MAJORVER-$RPCS3_GITVER"

RPCS3_SHA256=$(nix-prefetch-git --quiet --fetch-submodules https://github.com/RPCS3/rpcs3.git "$RPCS3_COMMIT" | jq -r .sha256)
echo "INFO: SHA256 is $RPCS3_SHA256"

sed -i -E \
    -e "s/majorVersion\s+.+$/majorVersion = \"${RPCS3_MAJORVER}\";/g" \
    -e "s/gitVersion\s+.+$/gitVersion = \"${RPCS3_GITVER}\";/g" \
    -e "s/rev\s*=\s*\"[a-z0-9]+\";$/rev = \"${RPCS3_COMMIT}\";/g" \
    -e "s/sha256\s*=\s*\"[a-z0-9]+\";$/sha256 = \"${RPCS3_SHA256}\";/g" \
    "$ROOT/default.nix"
