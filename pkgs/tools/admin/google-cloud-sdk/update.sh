#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix

CHANNEL_URL="https://dl.google.com/dl/cloudsdk/channels/rapid"
BASE_URL="$CHANNEL_URL/downloads/google-cloud-sdk"

# Version of Google Cloud SDK from
# https://cloud.google.com/sdk/docs/release-notes
VERSION="404.0.0"

function genMainSrc() {
    local url="${BASE_URL}-${VERSION}-${1}-${2}.tar.gz"
    local sha256
    sha256=$(nix-prefetch-url "$url")
    echo "      {"
    echo "        url = \"${url}\";"
    echo "        sha256 = \"${sha256}\";"
    echo "      };"
}

{
    cat <<EOF
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  googleCloudSdkPkgs = {
EOF

    echo "    x86_64-linux ="
    genMainSrc "linux" "x86_64"

    echo "    x86_64-darwin ="
    genMainSrc "darwin" "x86_64"

    echo "    aarch64-linux ="
    genMainSrc "linux" "arm"

    echo "    aarch64-darwin ="
    genMainSrc "darwin" "arm"

    echo "    i686-linux ="
    genMainSrc "linux" "x86"

    echo "  };"
    echo "}"

} >data.nix

curl "${CHANNEL_URL}/components-v${VERSION}.json" -w "\n" > components.json
