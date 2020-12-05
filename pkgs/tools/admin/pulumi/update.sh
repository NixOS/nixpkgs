#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="2.15.0"

# Grab latest release ${VERSION} from
# https://github.com/pulumi/pulumi-${NAME}/releases
plugins=(
    "auth0=1.3.0"
    "aws=3.19.0"
    "cloudflare=2.8.0"
    "consul=2.6.2"
    "datadog=2.11.0"
    "digitalocean=3.1.1"
    "docker=2.4.1"
    "gcp=4.4.0"
    "github=2.3.0"
    "gitlab=3.3.0"
    "hcloud=0.4.0"
    "kubernetes=2.7.3"
    "mailgun=2.3.1"
    "mysql=2.3.2"
    "openstack=2.9.0"
    "packet=3.2.2"
    "postgresql=2.5.2"
    "random=2.4.2"
    "vault=3.1.0"
    "vsphere=2.11.2"
    );

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

cat <<EOF                     > data.nix
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  pulumiPkgs = {
    x86_64-linux = [
EOF
genMainSrc "linux"           >> data.nix
genSrcs "linux"              >> data.nix
echo "    ];"                >> data.nix

echo "    x86_64-darwin = [" >> data.nix
genMainSrc "darwin"          >> data.nix
genSrcs "darwin"             >> data.nix
echo "    ];"                >> data.nix
echo "  };"                  >> data.nix
echo "}"                     >> data.nix

