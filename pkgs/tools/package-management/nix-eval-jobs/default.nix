{
  lib,
  boost,
  fetchFromGitHub,
  meson,
  ninja,
  curl,
  mimalloc,
  nlohmann_json,
  pkg-config,
  stdenv,
  nixComponents,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-eval-jobs";
  version = "2.35.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-eval-jobs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t1FbcjvTWQ1WO3hJNKN+viNXuz4BX9Pte5K4F+IJLDk=";
  };

  buildInputs = [
    boost
    curl
    mimalloc
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
})
