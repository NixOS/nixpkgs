{ lib
, boost
, cmake
, fetchFromGitHub
, meson
, ninja
, nixUnstable
, nlohmann_json
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "nix-eval-jobs";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LTMW4356f8pvIyfYdOyZbF9yzU8MH9mryQgB4LrwZMI=";
  };
  buildInputs = [
    boost
    nixUnstable
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
