#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq nix nix-prefetch-scripts moreutils

set -euxo pipefail

FILE="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" grafana).file' | tr -d '"')"
replaceHash() {
  old="${1?old hash missing}"
  new="${2?new hash missing}"
  awk -v OLD="$old" -v NEW="$new" '{
    if (i=index($0, OLD)) {
      $0 = substr($0, 1, i-1) NEW substr($0, i+length(OLD));
    }
    print $0;
  }' "$FILE" | sponge "$FILE"
}
extractVendorHash() {
  original="${1?original hash missing}"
  result="$(nix-build -A grafana.go-modules 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
  [ -z "$result" ] && { echo "$original"; } || { echo "$result"; }
}

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion grafana" | tr -d '"')"
latest="$(curl https://api.github.com/repos/grafana/grafana/releases/latest | jq '.tag_name' -r | tr -d 'v')"

targetVersion="${1:-$latest}"
if [ ! "${oldVersion}" = "${targetVersion}" ]; then
  update-source-version grafana "${targetVersion#v}"
  oldStaticHash="$(nix-instantiate --eval -A grafana.srcStatic.outputHash | tr -d '"')"
  newStaticHash="$(nix-prefetch-url "https://dl.grafana.com/oss/release/grafana-${targetVersion#v}.linux-amd64.tar.gz")"
  replaceHash "$oldStaticHash" "$newStaticHash"
  goHash="$(nix-instantiate --eval -A grafana.vendorSha256 | tr -d '"')"
  emptyHash="$(nix-instantiate --eval -A lib.fakeSha256 | tr -d '"')"
  replaceHash "$goHash" "$emptyHash"
  replaceHash "$emptyHash" "$(extractVendorHash "$goHash")"
  nix-build -A grafana
else
  echo "grafana is already up-to-date"
fi
