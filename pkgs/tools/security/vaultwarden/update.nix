{ writeShellApplication
, lib
, nix
, nix-prefetch-git
, nix-update
, curl
, git
, gnugrep
, gnused
, jq
, yq
}:

lib.getExe (writeShellApplication {
  name = "update-vaultwarden";
  runtimeInputs = [ curl git gnugrep gnused jq yq nix nix-prefetch-git nix-update ];

  text = ''
    VAULTWARDEN_VERSION=$(curl --silent https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest | jq -r '.tag_name')
    nix-update "vaultwarden" --version "$VAULTWARDEN_VERSION"

    URL="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/DockerSettings.yaml"
    WEBVAULT_VERSION="$(curl --silent "$URL" | yq -r ".vault_version" | sed s/^v//)"
    old_hash="$(nix --extra-experimental-features nix-command eval -f default.nix --raw vaultwarden.webvault.bw_web_builds.outputHash)"
    new_hash="$(nix-prefetch-git https://github.com/dani-garcia/bw_web_builds.git --rev "v$WEBVAULT_VERSION" | jq --raw-output ".sha256")"
    new_hash_sri="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$new_hash")"
    sed -e "s#$old_hash#$new_hash_sri#" -i pkgs/tools/security/vaultwarden/webvault.nix
    nix-update "vaultwarden.webvault" --version "$WEBVAULT_VERSION"
  '';
})
