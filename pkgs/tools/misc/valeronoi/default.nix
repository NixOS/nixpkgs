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
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "ccoors";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Xa70kOPQLavuJTF9PxCgpKYj15C2fna++cFlCId0a08=";
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
