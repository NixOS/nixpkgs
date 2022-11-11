{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "vgmtools";
  version = "unstable-2022-10-31";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "9d7a9f4b1c40d26949fa730987f6c3eb9cf3e3ec";
    sha256 = "Joxlu+k8xaF90u+ydHhu6NpqGQAKL8r5u4qAsfVfOz8=";
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
