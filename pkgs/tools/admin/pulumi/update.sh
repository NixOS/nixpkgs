#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="3.6.0"

# Grab latest release ${VERSION} from
# https://github.com/pulumi/pulumi-${NAME}/releases
plugins=(
    "auth0=2.2.0"
    "aws=4.10.0"
    "cloudflare=3.2.0"
    "consul=3.2.0"
    "datadog=3.3.0"
    "digitalocean=4.4.1"
    "docker=3.0.0"
    "equinix-metal=2.0.0"
    "gcp=5.11.0"
    "github=4.2.0"
    "gitlab=4.1.0"
    "hcloud=1.1.0"
    "kubernetes=3.5.0"
    "linode=3.2.0"
    "mailgun=3.1.0"
    "mysql=3.0.0"
    "openstack=3.2.0"
    "packet=3.2.2"
    "postgresql=3.1.0"
    "random=4.2.0"
    "vault=4.1.0"
    "vsphere=4.0.0"
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
    for plugVers in "${plugins[@]}"; do
        local plug=${plugVers%=*}
        local version=${plugVers#*=}
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

{
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
} > data.nix
