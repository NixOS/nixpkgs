#!/usr/bin/env bash
set -euo pipefail

sourcesFile=$1
version=${2:-$(curl --disable --fail --silent --show-error --retry 3 \
  https://api.github.com/repos/openatx/uiautomator2/releases/latest | jq -er .tag_name)}

checkVersion() {
  if [[ ! $1 =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
    echo "Unexpected or missing upstream version: $1" >&2
    exit 1
  fi
}

toSri() {
  nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$1"
}

checkVersion "$version"
sourceInfo=$(nix-prefetch-url --unpack --print-path \
  "https://github.com/openatx/uiautomator2/archive/refs/tags/$version.tar.gz")
sourceHash=$(toSri "$(head -n1 <<< "$sourceInfo")")
sourcePath=$(tail -n1 <<< "$sourceInfo")

jarVersion=$(sed -nE 's/^JAR_VERSION="([0-9.]+)"$/\1/p' "$sourcePath/uiautomator2/assets/sync.sh")
apkVersion=$(sed -nE "s/^__apk_version__ = ['\"]([0-9.]+)['\"]$/\\1/p" "$sourcePath/uiautomator2/version.py")
checkVersion "$jarVersion"
checkVersion "$apkVersion"
jarHash=$(nix-prefetch-url "https://github.com/openatx/android-uiautomator-server-jar/releases/download/$jarVersion/u2.jar")
apkHash=$(nix-prefetch-url "https://github.com/openatx/android-uiautomator-server/releases/download/$apkVersion/app-uiautomator.apk")
jarHash=$(toSri "$jarHash")
apkHash=$(toSri "$apkHash")

temporary=$(mktemp "${sourcesFile}.XXXXXX")
trap 'rm -f "$temporary"' EXIT
jq -n --arg version "$version" --arg sourceHash "$sourceHash" \
  --arg jarVersion "$jarVersion" --arg jarHash "$jarHash" \
  --arg apkVersion "$apkVersion" --arg apkHash "$apkHash" \
  '{version: $version, sourceHash: $sourceHash,
    serverJar: {version: $jarVersion, hash: $jarHash},
    serverApk: {version: $apkVersion, hash: $apkHash}}' > "$temporary"
chmod --reference="$sourcesFile" "$temporary"
mv "$temporary" "$sourcesFile"
