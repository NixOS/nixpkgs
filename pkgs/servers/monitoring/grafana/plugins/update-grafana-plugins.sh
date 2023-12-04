#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -eu -o pipefail

curl "https://grafana.com/api/plugins" | jq -r '
{
  "linux-amd64": "x86_64-linux",
  "linux-arm64": "aarch64-linux",
  "darwin-amd64": "x86_64-darwin",
  "darwin-arm64": "aarch64-darwin"
} as $arch_mapping | "{ callPackage }:
rec {
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  "
+ (
.items | sort_by(.slug) | map(.slug + " = grafanaPlugin {
    pname = \"" + .slug + "\";
    version = \"" + .version + "\";
    zipHash = "+ (if .packages | has("any") then
      "\"" + .packages.any.sha256 + "\""
    else
      "{" + (.packages | to_entries | map(.key as $key | if $arch_mapping | has($key) then
        "\n      " + $arch_mapping[.key] + " = \"" + .value.sha256 + "\";"
      else
        ""
      end) | join("")) + "\n    }"
    end) +";
    meta.description = \"" + .description + "\";
  };") | join("\n  ")
) + "
}"
' > plugins.nix
