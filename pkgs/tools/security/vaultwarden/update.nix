{ writeShellScript
, lib
, nix
, nix-prefetch-git
, nix-update
, curl
, git
, gnugrep
, gnused
, jq
}:

writeShellScript "update-vaultwarden" ''
  PATH=${lib.makeBinPath [ curl git gnugrep gnused jq nix nix-prefetch-git nix-update ]}

  set -euxo pipefail

  VAULTWARDEN_VERSION=$(curl --silent https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest | jq -r '.tag_name')
  nix-update "vaultwarden" --version "$VAULTWARDEN_VERSION"

  URL="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/Dockerfile.j2"
  WEBVAULT_VERSION=$(curl --silent "$URL" | grep "set vault_version" | sed -E "s/.*\"v([^\"]+)\".*/\\1/")
  old_hash=$(nix --extra-experimental-features nix-command eval -f default.nix --raw vaultwarden.webvault.bw_web_builds.outputHash)
  new_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $(nix-prefetch-git https://github.com/dani-garcia/bw_web_builds.git --rev "v$WEBVAULT_VERSION" | jq --raw-output ".sha256"))
  sed -e "s#$old_hash#$new_hash#" -i pkgs/tools/security/vaultwarden/webvault.nix
  nix-update "vaultwarden.webvault" --version "$WEBVAULT_VERSION"
''
