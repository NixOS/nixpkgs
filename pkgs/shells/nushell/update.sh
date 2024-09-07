#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p git nix-update nixpkgs-review nixfmt-rfc-style

set -euxo pipefail

basedir="$(git rev-parse --show-toplevel)"
cd "$basedir"

branch="update-nushell"
nuPath="pkgs/shells/nushell"

function staged() {
    if git status --porcelain | grep -q -E "^[AM].? +$1"; then
        return 0
    else
        return 1
    fi
}

function version() {
    grep '\s*version = ' "$nuPath/default.nix" | cut -d'"' -f 2 | head --lines 1
}

git checkout -B "$branch"

version_old=$(version)
if ! staged "$nuPath/default.nix"; then
    nix-update nushell
    git add "$nuPath/default.nix"
fi
version_new=$(version)

declare -a plugins=(formats query polars gstat)
for plugin in "${plugins[@]}"; do
    attr="nushellPlugins.$plugin"
    pluginPath="$nuPath/plugins/$plugin.nix"

    if staged "$pluginPath"; then
        echo "Skipping '$plugin' because it's alredy staged"
        continue
    fi

    echo "Attempting to build $attr"

    set +e
    newHash=$(nix build ".#$attr" 2> \
        >(grep got |
            awk -F' ' '{ print $2 }'))
    set -e

    # New hash ?
    if [ -n "$newHash" ]; then
        # Add the new hash
        sed -i "s!cargoHash = ".*";!cargoHash = \"$newHash\";!" "$pluginPath"
        nixfmt "$pluginPath"

        echo "Building $plugin again with new hash $newHash"
        nix build ".#$attr"
        git add "$pluginPath"
        echo "Plugin $plugin built sucessfully"
    else
        echo "No new hash for '$plugin'"
    fi
done

git commit -m "nushell: $version_old -> $version_new"

echo "Starting nixpkgs-review"
nixpkgs-review rev "$branch"
