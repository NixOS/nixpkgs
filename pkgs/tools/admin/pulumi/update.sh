#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="2.21.2"

# Grab latest release ${VERSION} from
# https://github.com/pulumi/pulumi-${NAME}/releases
plugins=(
    "auth0=1.8.1"
    "aws=3.30.1"
    "cloudflare=2.13.1"
    "consul=2.8.1"
    "datadog=2.16.1"
    "digitalocean=3.5.1"
    "docker=2.8.1"
    "gcp=4.12.0"
    "github=3.2.0"
    "gitlab=3.7.0"
    "hcloud=0.6.2"
    "kubernetes=2.8.2"
    "mailgun=2.4.1"
    "mysql=2.4.1"
    "openstack=2.15.0"
    "packet=3.2.2"
    "postgresql=2.7.2"
    "random=3.0.3"
    "vault=3.4.1"
    "vsphere=2.12.2"
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
