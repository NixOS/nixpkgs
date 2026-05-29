{
  lib,
  callPackage,
  git,
  installShellFiles,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:
let
  common = callPackage ./common.nix { };
in
rustPlatform.buildRustPackage {
  pname = "gradient-cli";

  inherit (common) src version;

  sourceRoot = "${common.src.name}/cli";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    git
    common.nixLatest
    (lib.getDev common.nixLatest)
    openssl
  ];

  cargoHash = common.cliCargoHash;

  NIX_INCLUDE_PATH = "${lib.getDev common.nixLatest}/include";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gradient \
      --bash <($out/bin/gradient completion bash) \
      --fish <($out/bin/gradient completion fish) \
      --zsh <($out/bin/gradient completion zsh)
  '';

  meta = {
    description = "cli tool for gradient a nix-based continuous integration system, as an alternative to Hydra";
    mainProgram = "gradient";
  };
}
