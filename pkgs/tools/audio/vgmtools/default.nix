{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
  version = "unstable-2022-12-03";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "b9216623ffb9219c46a7a10669175c7a4c8cd946";
    sha256 = "fPt/z4D4C8TWoz7FivxmXGDcYGc7sXWvxE0+CoyFgDQ=";
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
