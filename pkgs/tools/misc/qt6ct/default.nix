{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qtsvg
, qtwayland
, qmake
, qttools
, wrapQtAppsHook
}:
let
  inherit (lib) getDev;
in
stdenv.mkDerivation rec {
  pname = "qt6ct";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = "qt6ct";
    rev = version;
    sha256 = "BFE5aUgn3uFJWTgd4sUwP2L9RZwwwr5jVtAapA9vYbA=";
  };

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  buildInputs = [ qtbase qtsvg qtwayland ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "Qt6 Configuration Tool";
    homepage = "https://github.com/trialuser02/qt6ct";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ Flakebi Scrumplex ];
  };
}
