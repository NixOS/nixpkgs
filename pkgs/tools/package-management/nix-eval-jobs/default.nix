{
  lib,
  boost,
  fetchFromGitHub,
  meson,
  ninja,
  curl,
  nlohmann_json,
  pkg-config,
  stdenv,
  nixComponents,
}:
stdenv.mkDerivation rec {
  pname = "nix-eval-jobs";
  version = "2.34.3";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-eval-jobs";
    tag = "v${version}";
    hash = "sha256-YaVQAgBxWbUBFHXLBLzdUyVvuA/DDw80SEnn9iq0Veo=";
  };

  buildInputs = [
    boost
    curl
    nlohmann_json
    nixComponents.nix-store
    nixComponents.nix-fetchers
    nixComponents.nix-expr
    nixComponents.nix-flake
    nixComponents.nix-main
    nixComponents.nix-cmd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  # Since this package is intimately tied to a specific Nix release, we
  # propagate the Nix used for building it to make it easier for users
  # downstream to reference it.
  passthru = {
    inherit nixComponents;
    # For nix-fast-build
    nix = nixComponents.nix-cli;
  };

  meta = {
    description = "Hydra's builtin hydra-eval-jobs as a standalone";
    homepage = "https://github.com/NixOS/nix-eval-jobs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      adisbladis
      mic92
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-eval-jobs";
  };
}
