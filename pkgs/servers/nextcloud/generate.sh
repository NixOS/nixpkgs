#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../.. -i bash -p jq nc4nix nix-prefetch-github prefetch-npm-deps curl php.packages.composer gnused php

export composerNoDev=true
export composerNoPlugins=true
export composerNoScripts=true
export composerStrictValidation=false

tmp="$(mktemp -d)"

cp ../../build-support/php/builders/v2/hooks/composer-vendor-hook.sh "$tmp/composer-vendor-hook.sh"
sed -i "s#@phpScriptUtils@#../../build-support/php/builders/v2/hooks/php-script-utils.bash#" "$tmp/composer-vendor-hook.sh"
source "$tmp/composer-vendor-hook.sh"

set -euxo pipefail

curl --fail https://raw.githubusercontent.com/nextcloud-releases/updater_server/refs/heads/master/config/config.php -o "$tmp/config.php"
versions=($(echo "<?php print_r(json_encode(require_once '$tmp/config.php', JSON_THROW_ON_ERROR));"  | php | jq -r ".stable | with_entries(select(.key == \"31\" or .key == \"32\")) | map(.\"100\".latest) | sort | join(\" \")"))

echo "{}" > versions.json

for version in "${versions[@]}"; do
  tmp="$(mktemp -d)"

  repos=(documentation example-files server)

  git clone --depth 1 --branch "v$version" --recursive "https://github.com/nextcloud/server.git" "$tmp/server"

  apps=()
  for app in $(jq -r -c '.shippedApps.[]' "$tmp/server/core/shipped.json"); do
      # The source of the support app is not publicly available
      if [ ! -d "$tmp/server/apps/$app" ] && [[ "$app" != "support" ]]; then
        apps+=("$app")
      fi
  done

  jq -r ".\"$version\".extraApps=\$ARGS.positional" versions.json --args "${apps[@]}" > "$tmp/versions.json"
  mv "$tmp/versions.json" versions.json

  repos+=("${apps[@]}")

  for repo in "${repos[@]}"; do
    if [[ "$repo" != "server" ]]; then
      git clone --depth 1 --branch "v$version" --recursive "https://github.com/nextcloud/$repo.git" "$tmp/$repo"
    fi
    find "$tmp/$repo" -name .git -print0 | xargs -0 rm -rf

    jq -r ".\"$version\".hashes.\"$repo\".hash=\"$(nix-hash --type sha256 --sri "$tmp/$repo")\"" versions.json > "$tmp/versions.json"
    mv "$tmp/versions.json" versions.json

    if [ -f "$tmp/$repo/package-lock.json" ]; then
      jq -r ".\"$version\".hashes.\"$repo\".npmDepsHash=\"$(prefetch-npm-deps "$tmp/$repo/package-lock.json")\"" versions.json > "$tmp/versions.json"
      mv "$tmp/versions.json" versions.json
    fi

    if [ -f "$tmp/$repo/composer.lock" ]; then
      export out="$(mktemp -d -u)"
      export composerLock="$tmp/$repo/composer.lock"
      pushd "$(mktemp -d)"
      cp -r "$tmp/$repo/lib" "$tmp/$repo/composer.json" .
      composerVendorConfigureHook
      composerVendorBuildHook
      composerVendorCheckHook
      composerVendorInstallHook
      popd
      hash="$(nix-hash --type sha256 --sri "$out")"
      jq -r ".\"$version\".hashes.\"$repo\".vendorHash=\"$hash\"" versions.json > "$tmp/versions.json"
      mv "$tmp/versions.json" versions.json
    fi
  done
done

# Update apps
(
  export NEXTCLOUD_VERSIONS=$(jq -r 'keys|join(",")' versions.json)

  cd packages

  APPS=`cat nextcloud-apps.json | jq -r 'keys|.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

  nc4nix -apps $APPS
  rm *.log
)
