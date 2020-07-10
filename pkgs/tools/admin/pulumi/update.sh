#!/usr/bin/env bash

VERSION="2.2.1"

declare -A plugins
plugins=(
    ["aws"]="2.5.0"
    ["gcp"]="3.6.0"
    ["random"]="2.1.1"
    ["kubernetes"]="2.2.0"
    ["postgresql"]="2.1.1"
)

function genMainSrc() {
    local url="https://get.pulumi.com/releases/sdk/pulumi-v${VERSION}-$1-x64.tar.gz"
    local sha256
    sha256=$(nix-prefetch-url "$url")
    echo "      {"
    echo "        url = \"${url}\";"
    echo "        sha256 = \"$sha256\";"
    echo "      }"
}

function genSrcs() {
    for plug in "${!plugins[@]}"; do
        local version=${plugins[$plug]}
        # url as defined here
        # https://github.com/pulumi/pulumi/blob/06d4dde8898b2a0de2c3c7ff8e45f97495b89d82/pkg/workspace/plugins.go#L197
        local url="https://api.pulumi.com/releases/plugins/pulumi-resource-${plug}-v${version}-$1-amd64.tar.gz"
        local sha256
        sha256=$(nix-prefetch-url "$url")
        echo "      {"
        echo "        url = \"${url}\";"
        echo "        sha256 = \"$sha256\";"
        echo "      }"
    done
}

cat <<EOF
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  pulumiPkgs = {
    x86_64-linux = [
EOF
genMainSrc "linux"
genSrcs "linux"
echo "    ];"

echo "    x86_64-darwin = ["
genMainSrc "darwin"
genSrcs "darwin"
echo "    ];"
echo "  };"
echo "}"
