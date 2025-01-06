{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  opencl-headers,
  ocl-icd,
  qtbase,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "leela-zero";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "gcp";
    repo = "leela-zero";
    rev = "v${version}";
    hash = "sha256-AQRp2rkL9KCZdsJN6uz2Y+3kV4lyRLYjWn0p7UOjBMw=";
    fetchSubmodules = true;
  };

  buildInputs = [
    boost
    opencl-headers
    ocl-icd
    qtbase
    zlib
  ];

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  meta = {
    description = "Go engine modeled after AlphaGo Zero";
    homepage = "https://github.com/gcp/leela-zero";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      averelld
      omnipotententity
    ];
    platforms = lib.platforms.linux;
  };
}
