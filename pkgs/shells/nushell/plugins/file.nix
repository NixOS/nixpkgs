{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_file";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_file";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n/E7CpRLZvg+NWI+n3VzE+qrTKrpBbFNfSsHZEqRNiU=";
  };

  cargoHash = "sha256-rtzFq4iKzBnICwdhkoK7TSl6fgRUUXyedboZGmSM7qQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin that identifies file types";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
