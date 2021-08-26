#!/usr/bin/env bash

plugins=(
    "auth0"
    "aws"
    "cloudflare"
    "consul"
    "datadog"
    "digitalocean"
    "docker"
    "equinix-metal"
    "gcp"
    "github"
    "gitlab"
    "hcloud"
    "kubernetes"
    "linode"
    "mailgun"
    "mysql"
    "openstack"
    "postgresql"
    "random"
    "vault"
    "vsphere"
)


for plug in "${plugins[@]}"; do
    version=$(curl -s https://api.github.com/repos/pulumi/pulumi-${plug}/releases/latest | jq -r .tag_name)
    echo "    \"${plug}=${version}\""
done
