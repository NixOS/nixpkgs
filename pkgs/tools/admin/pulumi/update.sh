#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="3.11.0"

# Grab latest release ${VERSION} using get_latest_plugins.sh
plugins=(
    "auth0=v2.2.0"
    "aws=v4.17.0"
    "cloudflare=v3.4.0"
    "consul=v3.2.0"
    "datadog=v4.0.0"
    "digitalocean=v4.6.0"
    "docker=v3.0.0"
    "equinix-metal=v2.0.0"
    "gcp=v5.16.0"
    "github=v4.3.0"
    "gitlab=v4.2.0"
    "hcloud=v1.3.0"
    "kubernetes=v3.6.3"
    "linode=v3.3.1"
    "mailgun=v3.1.0"
    "mysql=v3.0.0"
    "openstack=v3.3.0"
    "postgresql=v3.1.0"
    "random=v4.2.0"
    "vault=v4.3.0"
    "vsphere=v4.0.1"
)

function genMainSrc() {
    local url="https://get.pulumi.com/releases/sdk/pulumi-v${VERSION}-$1.tar.gz"
    local sha256
    sha256=$(nix-prefetch-url "$url")
    echo "      {"
    echo "        url = \"${url}\";"
    echo "        sha256 = \"$sha256\";"
    echo "      }"
}

function genSrcs() {
    for plugVers in "${plugins[@]}"; do
        local plug=${plugVers%=*}
        local version=${plugVers#*=}
        # url as defined here
        # https://github.com/pulumi/pulumi/blob/06d4dde8898b2a0de2c3c7ff8e45f97495b89d82/pkg/workspace/plugins.go#L197
        local url="https://api.pulumi.com/releases/plugins/pulumi-resource-${plug}-${version}-$1.tar.gz"
        local sha256
        sha256=$(nix-prefetch-url "$url")
        echo "      {"
        echo "        url = \"${url}\";"
        echo "        sha256 = \"$sha256\";"
        echo "      }"
    done
}

{
  cat <<EOF
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  pulumiPkgs = {
    x86_64-linux = [
EOF
  genMainSrc "linux-x64"
  genSrcs "linux-amd64"
  echo "    ];"
  echo "    x86_64-darwin = ["

  genMainSrc "darwin-x64"
  genSrcs "darwin-amd64"
  echo "    ];"
  echo "    aarch64-darwin = ["

  genMainSrc "darwin-arm64"
  genSrcs "darwin-arm64"
  echo "    ];"
  echo "  };"
  echo "}"
} > data.nix

