{ lib
, stdenv
, fetchFromGitHub
, boost
, cgal
, cmake
, copyDesktopItems
, gpp
, mpfr
, qtbase
, qtimageformats
, qtsvg
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "valeronoi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ccoors";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4BTBF6h/BEVr0E3E0EvvKOQGHZ4wCtdXgKBWLSfOcOI=";
  };

  buildInputs = [
    boost
    cgal
    gpp
    mpfr
    qtbase
    qtimageformats
    qtsvg
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    wrapQtAppsHook
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ccoors/Valeronoi/";
    description = "A WiFi mapping companion app for Valetudo";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nova-madeline maeve ];
  };
}
