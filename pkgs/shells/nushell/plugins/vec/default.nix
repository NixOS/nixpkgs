{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

let
  version = "1.1.6";
in
rustPlatform.buildRustPackage {
  pname = "nu_plugin_vec";
  inherit version;

  src = fetchFromGitHub {
    repo = "nu_plugin_vec";
    owner = "PhotonBursted";
    tag = "v${version}";
    hash = "sha256-Trkg46t2xaIr0Z45XFiQ+RqA3Emt9gWRCVZ3JJG/7lM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gdutANASt2QEaVmuqpRjzuhOT3sTFJb9fK2BXkUMKaM=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoPatches = [ ./lock.diff ];
  patches = [ ./toml.diff ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin that adds support for vector operations";
    longDescription = ''
      NOTE: This package has been patched for the current version of nushell (0.104.0).
      The author of this plugin does not have a version for this particular version of nushell.
    '';
    mainProgram = "nu_plugin_vec";
    homepage = "https://github.com/PhotonBursted/nu_plugin_vec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldenparker ];
    platforms = lib.platforms.all;
  };
}
