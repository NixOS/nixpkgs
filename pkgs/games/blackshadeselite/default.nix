{stdenv, fetchsvn, SDL, mesa, openal, libvorbis, freealut, SDL_image, popt}:

stdenv.mkDerivation rec {
  name = "blackshades-elite-svn-29";
  src = fetchsvn {
    url = svn://svn.gna.org/svn/blackshadeselite/trunk;
    rev = 29;
    sha256 = "1lkws5pqpgcgdlar11waikp6y41z678457n9jcik7nhn53cjjr1s";
  };

  NIX_LDFLAGS = "-lSDL_image";

  buildInputs = [ SDL SDL_image mesa openal libvorbis freealut popt ];

  patchPhase = ''
    sed -i -e s,Data/,$out/opt/$name/Data/,g \
      -e s,Data:,$out/opt/$name/Data/,g \
      Source/*.cpp
    sed -i -e s/-march=pentium-m// Makefile
    sed -i -e '/include "Window.h"/a#include <cstring>' -e 's/strcmp/std::strcmp/' \
      Source/Window.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/$name
    cp objs/blackshades $out/bin/blackshadeselite
    cp -R Data IF* Readme $out/opt/$name/
  '';

  meta = {
    homepage = http://home.gna.org/blackshadeselite/;
    description = "Fork of Black Shades";
    license = "GPLv2+"; # Says its gna.org project page
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
