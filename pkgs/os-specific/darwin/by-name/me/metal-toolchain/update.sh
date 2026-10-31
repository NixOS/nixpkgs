#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p _7zz cacert common-updater-scripts coreutils curl gnused ipsw jq nix python3
# shellcheck shell=bash

set -euo pipefail

indexUrl='https://devimages-cdn.apple.com/downloads/xcode/simulators/index2.dvtdownloadableindex'
catalogUrl='https://gdmf.apple.com/v2/assets'
# Production audience UUID, observed in Xcode's DVTFoundation next to the catalog URL.
assetAudience='02d8e57e-dd1c-4090-aa50-b4ed2aef0062'
assetType='com.apple.MobileAsset.MetalToolchain'

pkgdir=$(dirname "$(realpath "$0")")
packageNix=$pkgdir/package.nix
nixpkgsRoot=$(dirname "$pkgdir")/../../../../..
cd "$nixpkgsRoot"

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT

# gdmf.apple.com chains to the 2006 "Apple Root CA", which Mozilla-based CA
# bundles do not include. Only the catalog call needs this root; the other
# curls use the nixpkgs CA bundle. SHA-256 fingerprint:
# B0:B1:73:0E:CB:C7:FF:45:05:14:2C:49:F1:29:5E:6E:DA:6B:CA:ED:7E:2C:68:C5:BE:91:B5:A1:10:01:F0:24
appleRootCa=$tmp/apple-root-ca.pem
cat >"$appleRootCa" <<'PEM'
-----BEGIN CERTIFICATE-----
MIIEuzCCA6OgAwIBAgIBAjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzET
MBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMDYwNDI1MjE0
MDM2WhcNMzUwMjA5MjE0MDM2WjBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBw
bGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkx
FjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDkkakJH5HbHkdQ6wXtXnmELes2oldMVeyLGYne+Uts9QerIjAC6Bg+
+FAJ039BqJj50cpmnCRrEdCju+QbKsMflZ56DKRHi1vUFjczy8QPTc4UadHJGXL1
XQ7Vf1+b8iUDulWPTV0N8WQ1IxVLFVkds5T39pyez1C6wVhQZ48ItCD3y6wsIG9w
tj8BMIy3Q88PnT3zK0koGsj+zrW5DtleHNbLPbU6rfQPDgCSC7EhFi501TwN22IW
q6NxkkdTVcGvL0Gz+PvjcM3mo0xFfh9Ma1CWQYnEdGILEINBhzOKgbEwWOxaBDKM
aLOPHd5lc/9nXmW8Sdh2nzMUZaF3lMktAgMBAAGjggF6MIIBdjAOBgNVHQ8BAf8E
BAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUK9BpR5R2Cf70a40uQKb3
R01/CF4wHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wggERBgNVHSAE
ggEIMIIBBDCCAQAGCSqGSIb3Y2QFATCB8jAqBggrBgEFBQcCARYeaHR0cHM6Ly93
d3cuYXBwbGUuY29tL2FwcGxlY2EvMIHDBggrBgEFBQcCAjCBthqBs1JlbGlhbmNl
IG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0
YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBj
b25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZp
Y2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMA0GCSqGSIb3DQEBBQUAA4IBAQBc
NplMLXi37Yyb3PN3m/J20ncwT8EfhYOFG5k9RzfyqZtAjizUsZAS2L70c5vu0mQP
y3lPNNiiPvl4/2vIB+x9OYOLUyDTOMSxv5pPCmv/K/xZpwUJfBdAVhEedNO3iyM7
R6PVbyTi69G3cN8PReEnyvFteO3ntRcXqNx+IjXKJdXZD9Zr1KIkIxH3oayPc4Fg
xhtbCS+SsvhESPBgOJ4V9T0mZyCKM2r3DYLP3uujL/lTaltkwGMzd/c6ByxW69oP
IQ7aunMZT7XZNn/Bh1XZp5m5MkL72NVxnn6hUrcbvZNCJBIqxw8dtk2cXmPIS4AX
UKqK1drk/NAJBzewdXUh
-----END CERTIFICATE-----
PEM

currentUrl=$(nix-instantiate --eval --raw -E 'with import ./. {}; darwin.metal-toolchain.src.url')

curl -sSfL "$indexUrl" -o "$tmp/index.plist"
newestBuild=$(
  python3 - "$tmp/index.plist" <<'PY'
import plistlib
import re
import sys

stable = []
with open(sys.argv[1], "rb") as f:
    index = plistlib.load(f)

for entry in index.get("otherDownloadables", []):
    # Release trains look like metalToolchain_26_6 / _26_4_1; all other
    # identifiers carry letters (…_26_5_b1, _26_4_rc, _26_3_hw, …_26_1b1).
    m = re.fullmatch(
        r"com\.apple\.Xcode\.metalToolchain_([0-9]+(?:_[0-9]+)*)",
        entry["identifier"],
    )
    if m:
        stable.append((tuple(int(part) for part in m.group(1).split("_")), entry))

train = max(train for train, _ in stable)
# Apple lists a train's updates in chronological order; the last entry wins.
print(
    [entry for candidate, entry in stable if candidate == train][-1]["assetBuildUpdate"]
)
PY
)

query=$(jq --null-input --compact-output --arg assetType "$assetType" --arg audience "$assetAudience" --arg build "$newestBuild" \
  '{ClientVersion: 2, AssetType: $assetType, AssetAudience: $audience, RequestedBuild: $build}')
curl -sSfL --cacert "$appleRootCa" "$catalogUrl" -H 'Content-Type: application/json' -d "$query" -o "$tmp/catalog.txt"
python3 - "$tmp/catalog.txt" >"$tmp/asset.json" <<'PY'
import base64
import json
import sys

with open(sys.argv[1]) as f:
    segments = f.read().strip().split(".")

payload = segments[1] + "=" * (-len(segments[1]) % 4)
json.dump(json.loads(base64.urlsafe_b64decode(payload))["Assets"][0], sys.stdout)
PY

assetMetadata=$(jq --exit-status --raw-output '[
    .__BaseURL, .__RelativePath, .["_Measurement-SHA256"], .ArchiveDecryptionKey
  ] | if all(. != null) then @tsv else error("missing field") end
' "$tmp/asset.json")
IFS=$'\t' read -r assetBaseUrl assetRelativePath assetHash newKey <<<"$assetMetadata"
newUrl="$assetBaseUrl$assetRelativePath"
newHash="sha256-$assetHash"

if [[ $newUrl = "$currentUrl" ]]; then
  echo "already up to date: build $newestBuild"
  exit 0
fi

echo "downloading $newUrl" >&2
curl -sSfL "$newUrl" -o "$tmp/toolchain.aar"

# The toolchain cannot execute on Linux, so read the version statically: the
# version metal --version prints is the first two numeric components of the
# ToolchainInfo.plist identifier (a trailing build component is not part of it).
ipsw ota extract --key-val "$newKey" --output "$tmp/ota" --pattern 'AssetData/Restore/.*\.dmg$' --confirm "$tmp/toolchain.aar"
dmg=("$tmp"/ota/*/AssetData/Restore/*.dmg)
7zz x -y -o"$tmp/dmg" "${dmg[0]}" 'Metal.xctoolchain/ToolchainInfo.plist' >/dev/null
newVersion=$(
  python3 - "$tmp/dmg/Metal.xctoolchain/ToolchainInfo.plist" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as f:
    info = plistlib.load(f)

parts = info["Identifier"].removeprefix("com.apple.dt.toolchain.Metal.").split(".")
print(".".join(parts[:2]))
PY
)

echo "updating to $newVersion (build $newestBuild)"
update-source-version darwin.metal-toolchain "$newVersion" "$newHash" "$newUrl" --file="$packageNix" --ignore-same-version

# The decryption key is not a source attribute, so update it directly.
sed -i -E "s|(decryptionKey = \")[^\"]*(\";)|\1$newKey\2|" "$packageNix"

echo "updated darwin.metal-toolchain to $newVersion"
