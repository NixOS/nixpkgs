{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
  version = "unstable-2023-06-29";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "e1f3e053e390bde6bd53b81bd853a0298ccb0ab4";
    hash = "sha256-evIvW9Nk9g7R+EmaQXLmr0ecpAS5Ashditk3komBwyw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  # Some targets are not enabled by default
  makeFlags = [
    "all" "optdac" "optvgm32"
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
