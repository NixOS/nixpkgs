{
  lib,
  callPackage,
  git,
  installShellFiles,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:
let
  common = callPackage ./common.nix { };
in
rustPlatform.buildRustPackage {
  pname = "gradient-server";

  inherit (common) src version;

  sourceRoot = "${common.src.name}/backend";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    git
    common.nixLatest
    (lib.getDev common.nixLatest)
    openssl
    zstd
  ];

  cargoHash = common.serverCargoHash;

  NIX_INCLUDE_PATH = "${lib.getDev common.nixLatest}/include";

  meta = common.meta // {
    description = "nix-based continuous integration system, as an alternative to Hydra";
    platforms = lib.platforms.unix;
    mainProgram = "gradient-server";
  };
}
