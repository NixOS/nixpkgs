{ stdenv, fetchgit, qt5, box2d, which, cmake, gettext }:

stdenv.mkDerivation rec {
  name = "tbe-${version}";
  version = "0.9.3.1";

  src = fetchgit {
    url = "https://github.com/kaa-ching/tbe";
    rev = "refs/tags/v${version}";
    sha256 = "1ag2cp346f9bz9qy6za6q54id44d2ypvkyhvnjha14qzzapwaysj";
  };

  postPatch = "sed '1i#include <vector>' -i src/model/World.h";

  buildInputs = [
    qt5.qtbase qt5.qtsvg qt5.qttranslations box2d which cmake
    gettext
  ];
  enableParallelBuilding = true;

  installPhase = ''
    make DESTDIR=.. install
    mkdir -p $out/bin
    cp ../usr/games/tbe $out/bin
    cp -r ../usr/share $out/
  '';

  meta = with stdenv.lib; {
    description = "A physics-based game vaguely similar to Incredible Machine";
    homepage = http://the-butterfly-effect.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
