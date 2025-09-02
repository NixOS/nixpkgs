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
  version = "2.30.0-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-eval-jobs";
    rev = "375fabe319a746e3ae92f4bbf599af67c57d8fc6";
    hash = "sha256-IE81n/M/I3+bjDHY4MS/G7NuQ6mh45WvITl9IDy8gp4=";
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
    homepage = "https://github.com/nix-community/nix-eval-jobs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      adisbladis
      mic92
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-eval-jobs";
  };
}
