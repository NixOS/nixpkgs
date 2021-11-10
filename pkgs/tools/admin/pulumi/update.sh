#!/usr/bin/env bash
# Bash 3 compatible for Darwin

# For getting the latest version of plugins automatically
API_URL="https://api.github.com/repos/pulumi"

# Version of Pulumi from
# https://www.pulumi.com/docs/get-started/install/versions/
VERSION="3.17.0"

# A hashmap containing a plugin's name and it's respective repository inside
# Pulumi's Github organization

declare -A pulumi_repos
pulumi_repos=(
    ["auth0"]="pulumi-auth0"
    ["aws"]="pulumi-aws"
    ["azure"]="pulumi-azure"
    ["cloudflare"]="pulumi-cloudflare"
    ["consul"]="pulumi-consul"
    ["datadog"]="pulumi-datadog"
    ["digitalocean"]="pulumi-digitalocean"
    ["docker"]="pulumi-docker"
    ["equinix-metal"]="pulumi-equinix-metal"
    ["gcp"]="pulumi-gcp"
    ["github"]="pulumi-github"
    ["gitlab"]="pulumi-gitlab"
    ["hcloud"]="pulumi-hcloud"
    ["kubernetes"]="pulumi-kubernetes"
    ["linode"]="pulumi-linode"
    ["mailgun"]="pulumi-mailgun"
    ["mysql"]="pulumi-mysql"
    ["openstack"]="pulumi-openstack"
    ["packet"]="pulumi-packet"
    ["postgresql"]="pulumi-postgresql"
    ["random"]="pulumi-random"
    ["vault"]="pulumi-vault"
    ["vsphere"]="pulumi-vsphere"
)

# Contains latest release ${VERSION} from
# https://github.com/pulumi/pulumi-${NAME}/releases

# Dynamically builds the plugin array, using the hashmap's key/values and the
# API for getting the latest version.
plugins=()
for key in "${!pulumi_repos[@]}"; do
    plugins+=("${key}=$(curl -s ${API_URL}/${pulumi_repos[${key}]}/releases/latest | jq -M -r .tag_name | sed 's/v//g')")
    sleep 1
done

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
