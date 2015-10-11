{ stdenv, fetchurl, mesa, libX11, xproto, tcl, freeglut
, SDL, SDL_mixer, SDL_image, libXi, inputproto
, libXmu, libXext, xextproto, libXt, libSM, libICE
, libpng, pkgconfig, gettext, intltool
}:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "extremetuxracer-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${version}.tar.xz";
    sha256 = "0fl9pwkywqnsmgr6plfj9zb05xrdnl5xb2hcmbjk7ap9l4cjfca4";
  };

  buildInputs = [
    mesa libX11 xproto tcl freeglut
    SDL SDL_mixer SDL_image libXi inputproto
    libXmu libXext xextproto libXt libSM libICE
    libpng pkgconfig gettext intltool
  ];

  configureFlags = [ "--with-tcl=${tcl}/lib" ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL.dev}/include/SDL"
  '';

  meta = {
    description = "High speed arctic racing game based on Tux Racer";
    longDescription = ''
      ExtremeTuxRacer - Tux lies on his belly and accelerates down ice slopes.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://sourceforge.net/projects/extremetuxracer/;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
