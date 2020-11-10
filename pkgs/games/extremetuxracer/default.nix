{ stdenv, fetchurl, libGLU, libGL, libX11, xorgproto, tcl, freeglut, freetype
, sfml, libXi
, libXmu, libXext, libXt, libSM, libICE
, libpng, pkgconfig, gettext, intltool
}:

stdenv.mkDerivation rec {
  version = "0.8.0";
  pname = "extremetuxracer";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${version}.tar.xz";
    sha256 = "05ysaxvsgps9fxc421kdifsxmc1sn6n79cjaa0k0i3fs9qqrja2b";
  };

  buildInputs = [
    libGLU libGL libX11 xorgproto tcl freeglut freetype
    sfml libXi
    libXmu libXext libXt libSM libICE
    libpng pkgconfig gettext intltool
  ];

  configureFlags = [ "--with-tcl=${tcl}/lib" ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE"
  '';

  meta = {
    description = "High speed arctic racing game based on Tux Racer";
    longDescription = ''
      ExtremeTuxRacer - Tux lies on his belly and accelerates down ice slopes.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "https://sourceforge.net/projects/extremetuxracer/";
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
