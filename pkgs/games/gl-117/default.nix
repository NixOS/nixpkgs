{ lib, stdenv, fetchurl
, libGLU, libGL, SDL, freeglut, SDL_mixer, autoconf, automake, libtool
}:

stdenv.mkDerivation rec {
  pname = "gl-117";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/gl-117/gl-117/GL-117%20Source/${pname}-${version}.tar.bz2";
    sha256 = "1yvg1rp1yijv0b45cz085b29x5x0g5fkm654xdv5qwh2l6803gb4";
  };

  nativeBuildInputs = [ automake autoconf ];
  buildInputs = [ libGLU libGL SDL freeglut SDL_mixer libtool ];

  meta = with lib; {
    description = "An air combat simulator";
    homepage = "https://sourceforge.net/projects/gl-117";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
