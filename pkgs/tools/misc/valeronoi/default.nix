{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cgal,
  cmake,
  gpp,
  mpfr,
  qtbase,
  qtimageformats,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "valeronoi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ccoors";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7z967y1hWpitZfXNlHHM8qEBdyuBQSFlJElS4ldsAaE=";
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
    wrapQtAppsHook
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ccoors/Valeronoi/";
    description = "A WiFi mapping companion app for Valetudo";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      nova-madeline
      maeve
    ];
    mainProgram = "valeronoi";
  };
}
