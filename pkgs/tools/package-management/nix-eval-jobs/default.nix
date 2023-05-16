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
<<<<<<< HEAD
  version = "2.17.0";
=======
  version = "2.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5rhsYKYKKOxv9aL2dPcFehdHcO58+ptG4CWaSYR6lfo=";
=======
    hash = "sha256-fpksS7lbaYwjf7NuPFE44wvyGcT5d+ERBCJmZoKXaWA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
