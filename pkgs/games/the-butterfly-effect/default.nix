{ lib, mkDerivation, fetchFromGitHub, qt5, box2d, which, cmake, gettext }:

mkDerivation rec {
  pname = "tbe";
  version = "0.9.3.1";

  src = fetchFromGitHub {
    owner = "kaa-ching";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1ag2cp346f9bz9qy6za6q54id44d2ypvkyhvnjha14qzzapwaysj";
  };

  postPatch = "sed '1i#include <vector>' -i src/model/World.h";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    qt5.qtbase qt5.qtsvg qt5.qttranslations box2d which
    gettext
  ];

  installPhase = ''
    make DESTDIR=.. install
    mkdir -p $out/bin
    cp ../usr/games/tbe $out/bin
    cp -r ../usr/share $out/
  '';

  meta = with lib; {
    description = "A physics-based game vaguely similar to Incredible Machine";
    homepage = "http://the-butterfly-effect.org/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
