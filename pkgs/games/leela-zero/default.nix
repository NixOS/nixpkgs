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
    sha256 = "sha256-AQRp2rkL9KCZdsJN6uz2Y+3kV4lyRLYjWn0p7UOjBMw=";
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

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage = "https://github.com/gcp/leela-zero";
    license = licenses.gpl3Plus;
    maintainers = [
      maintainers.averelld
      maintainers.omnipotententity
    ];
    platforms = platforms.linux;
  };
}
