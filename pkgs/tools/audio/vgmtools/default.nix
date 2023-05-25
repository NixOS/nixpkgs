{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
  version = "unstable-2023-04-17";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "894fb43d584e31efe0c7070ba9b6b85938012745";
    sha256 = "BGL7Lm6U1QdYZgEnn9tGgY+z8Fhjj+Sd2Cesn1sxWhY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  # Some targets are not enabled by default
  makeFlags = [
    "all" "opt_oki" "optdac" "optvgm32"
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
