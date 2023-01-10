{ writeShellScript
, lib
, nix-update
, curl
, git
, gnugrep
, gnused
, jq
}:

writeShellScript "update-vaultwarden" ''
  PATH=${lib.makeBinPath [ curl git gnugrep gnused jq nix-update ]}

  set -euxo pipefail

  VAULTWARDEN_VERSION=$(curl --silent https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest | jq -r '.tag_name')
  nix-update "vaultwarden" --version "$VAULTWARDEN_VERSION"

  URL="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/Dockerfile.j2"
  WEBVAULT_VERSION=$(curl --silent "$URL" | grep "set vault_version" | sed -E "s/.*\"([^\"]+)\".*/\\1/")
  nix-update "vaultwarden.webvault" --version "$WEBVAULT_VERSION"
''
