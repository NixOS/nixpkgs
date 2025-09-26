#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../.. -i bash -p jq nc4nix nix-prefetch-github prefetch-npm-deps wget

set -euxo pipefail

out="$(mktemp)"
for version in $(jq -r 'keys|join(" ")' versions.json); do
  major="$(echo "$version" | cut -d "." -f 1)"
  jq -r ".\"$version\".hashes.documentation.src=\"\"" versions.json > "$out"
  mv "$out" versions.json

  for repo in example-files server activity app_api bruteforcesettings circles files_downloadlimit files_pdfviewer firstrunwizard logreader nextcloud_announcements notifications password_policy photos privacy recommendations related_resources serverinfo survey_client suspicious_login text twofactor_nextcloud_notification twofactor_totp viewer; do
    if [[ "$(jq -r ".\"$version\".hashes.\"$repo\"" versions.json)" == "null" ]]; then
      drv="$(nix-prefetch-github --json --no-deep-clone --fetch-submodules --rev "v$version" nextcloud "$repo")"

      jq -r ".\"$version\".hashes.\"$repo\".src=\"$(echo "$drv" | jq -r '.hash')\"" versions.json > "$out"
      mv "$out" versions.json

      if [[ "$repo" != example-files ]] && [[ "$repo" != circles ]] && [[ "$repo" != nextcloud_announcements ]] && [[ "$repo" != serverinfo ]]  && [[ "$repo" != survey_client ]] && ([[ "$repo" != suspicious_login ]] || [[ "$major" == 30 ]]); then
        tmp="$(mktemp)"
        wget "https://raw.githubusercontent.com/nextcloud/$repo/refs/tags/v$version/package-lock.json" -O "$tmp"

        jq -r ".\"$version\".hashes.\"$repo\".npmDeps=\"$(prefetch-npm-deps "$tmp")\"" versions.json > "$out"
        mv "$out" versions.json
      fi

      if [[ "$repo" != example-files ]] && [[ "$repo" != server ]]; then
        jq -r ".\"$version\".hashes.\"$repo\".vendor=\"\"" versions.json > "$out"
        mv "$out" versions.json
      fi
    fi
  done
done

exit 0

# Update apps
(
  export NEXTCLOUD_VERSIONS=$(jq -r 'keys|join(",")' versions.json)

  cd packages

  APPS=`cat nextcloud-apps.json | jq -r 'keys|.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

  nc4nix -apps $APPS
  rm *.log
)
