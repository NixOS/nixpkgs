{ stdenv, fetchFromGitHub, qmake, pkgconfig, gtk3, libnotify }:

stdenv.mkDerivation rec {
  name = "gtkplatform-2017-09-25";
  src = fetchFromGitHub {
    owner = "CrimsonAS";
    repo = "gtkplatform";
    rev = "7f72dbca58794d9bd15efc7f2c3ae43aea0dc263";
    sha256 = "1pbzhaqkbapca50x6n8fkdg8aqzss02bn63pr9sizl5a2d4b9y2m";
  };

  enableParallelBuilding = true;

  buildInputs = [ gtk3 libnotify ];
  nativeBuildInputs = [ qmake pkgconfig ];

  installPhase = ''
    make INSTALL_ROOT=$NIX_QT5_TMP install
    mv $NIX_QT5_TMP/$NIX_QT5_TMP $out
  '';
}
