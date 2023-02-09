{ lib
, boost
, cmake
, fetchFromGitHub
, meson
, ninja
, nix
, nlohmann_json
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "nix-eval-jobs";
  version = "2.13.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O0Ro9vwf2kDhGFs32puQIeW/rSSduC9sD5zV8e/GtvA=";
  };
  buildInputs = [
    boost
    nix
    nlohmann_json
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # nlohmann_json can be only discovered via cmake files
    cmake
  ];

  meta = {
    description = "Hydra's builtin hydra-eval-jobs as a standalone";
    homepage = "https://github.com/nix-community/nix-eval-jobs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ adisbladis mic92 ];
    platforms = lib.platforms.unix;
  };
}
