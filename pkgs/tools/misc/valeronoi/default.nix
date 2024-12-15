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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ccoors";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5KXVSIqWDkXnpO+qgBzFtbJb444RW8dIVXp8Y/aAOrk=";
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
    description = "WiFi mapping companion app for Valetudo";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      nova-madeline
      maeve
    ];
    mainProgram = "valeronoi";
  };
}
