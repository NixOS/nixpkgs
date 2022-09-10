{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
  version = "unstable-2022-08-03";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "a33c7b9d7c7608a3cfebbee4467c6909b42077d6";
    sha256 = "oVasSToGp2APfaD/xCt/3SwvGq7JtpP8VVDRPznYDH4=";
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
