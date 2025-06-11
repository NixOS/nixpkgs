{
  lib,
  boost,
  cmake,
  fetchFromGitHub,
  meson,
  ninja,
  curl,
  nix,
  nlohmann_json,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "nix-eval-jobs";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AJ22q6yWc1hPkqssXMxQqD6QUeJ6hbx52xWHhKsmuP0=";
  };

  buildInputs = [
    boost
    nix
    curl
    nlohmann_json
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Since this package is intimately tied to a specific Nix release, we
  # propagate the Nix used for building it to make it easier for users
  # downstream to reference it.
  passthru = { inherit nix; };

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
