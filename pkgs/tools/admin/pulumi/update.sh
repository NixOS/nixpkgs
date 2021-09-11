#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="3.12.0"

# Grab latest release ${VERSION} from
# https://github.com/pulumi/pulumi-${NAME}/releases
plugins=(
    "auth0=2.2.0"
    "aws=4.19.0"
    "cloudflare=3.5.0"
    "consul=3.3.0"
    "datadog=4.1.0"
    "digitalocean=4.6.1"
    "docker=3.1.0"
    "equinix-metal=2.0.0"
    "gcp=5.18.0"
    "github=4.3.0"
    "gitlab=4.2.0"
    "hcloud=1.4.0"
    "kubernetes=3.7.0"
    "linode=3.3.2"
    "mailgun=3.1.0"
    "mysql=3.0.0"
    "openstack=3.3.0"
    "packet=3.2.2"
    "postgresql=3.2.0"
    "random=4.2.0"
    "vault=4.4.0"
    "vsphere=4.0.1"
)

function genMainSrc() {
    local url="https://get.pulumi.com/releases/sdk/pulumi-v${VERSION}-${1}-${2}.tar.gz"
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
        local url="https://api.pulumi.com/releases/plugins/pulumi-resource-${plug}-v${version}-${1}-${2}.tar.gz"
        local sha256
        sha256=$(nix-prefetch-url "$url")
        if [ "$sha256" ]; then  # file exists
            echo "      {"
            echo "        url = \"${url}\";"
            echo "        sha256 = \"$sha256\";"
            echo "      }"
        else
            echo "      # pulumi-resource-${plug} skipped (does not exist on remote)"
        fi
    done
}

{
  cat <<EOF
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  pulumiPkgs = {
EOF

  echo "    x86_64-linux = ["
  genMainSrc "linux" "x64"
  genSrcs "linux" "amd64"
  echo "    ];"

  echo "    x86_64-darwin = ["
  genMainSrc "darwin" "x64"
  genSrcs "darwin" "amd64"
  echo "    ];"

  echo "    aarch64-linux = ["
  genMainSrc "linux" "arm64"
  genSrcs "linux" "arm64"
  echo "    ];"

  echo "    aarch64-darwin = ["
  genMainSrc "darwin" "arm64"
  genSrcs "darwin" "arm64"
  echo "    ];"

  echo "  };"
  echo "}"

} > data.nix
