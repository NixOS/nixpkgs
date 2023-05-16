#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils common-updater-scripts jq curl

set -euo pipefail

currentVersion="$(nix --extra-experimental-features nix-command eval -f . github-runner.version --raw)"
latestVersion="$(curl -s -H "Accept: application/vnd.github.v3+json" \
            ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
            "https://api.github.com/repos/actions/runner/releases/latest" | jq -r ".tag_name")"
latestVersion="${latestVersion#?}" # v2.296.2 -> 2.296.2

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "github-runner is already up to date: $currentVersion"
    exit
fi

update-source-version github-runner "$latestVersion"
<<<<<<< HEAD
$(nix-build -A github-runner.fetch-deps --no-out-link)
=======
$(nix-build -A github-runner.fetch-deps --no-out-link) "$(dirname "$BASH_SOURCE")/deps.nix"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

