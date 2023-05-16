{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
<<<<<<< HEAD
  version = "unstable-2023-08-27";
=======
  version = "unstable-2023-04-17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
<<<<<<< HEAD
    rev = "7b7f2041e346f0d4fff8c834a763edc4f4d88896";
    hash = "sha256-L52h94uohLMnj29lZj+i9hM8n9hIYo20nRS8RCW8npY=";
=======
    rev = "894fb43d584e31efe0c7070ba9b6b85938012745";
    sha256 = "BGL7Lm6U1QdYZgEnn9tGgY+z8Fhjj+Sd2Cesn1sxWhY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  # Some targets are not enabled by default
  makeFlags = [
<<<<<<< HEAD
    "all" "optdac" "optvgm32"
=======
    "all" "opt_oki" "optdac" "optvgm32"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vgmrips/vgmtools.git";
  };

  meta = with lib; {
    homepage = "https://github.com/vgmrips/vgmtools";
    description = "A collection of tools for the VGM file format";
    license = licenses.gpl2; # Not clarified whether Only or Plus
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
