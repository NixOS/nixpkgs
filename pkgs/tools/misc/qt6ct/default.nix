{ stdenv, lib, fetchFromGitHub, qtbase, qtsvg, qttools, qmake, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "qt6ct";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = pname;
    rev = version;
    hash = "sha256-BFE5aUgn3uFJWTgd4sUwP2L9RZwwwr5jVtAapA9vYbA=";
  };

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  buildInputs = [ qtbase qtsvg ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${lib.getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "Qt6 Configuration Tool";
    homepage = "https://github.com/trialuser02/qt6ct";
    changelog = "https://github.com/trialuser02/qt6ct/releases/tag/${version}";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ Flakebi ];
  };
}
