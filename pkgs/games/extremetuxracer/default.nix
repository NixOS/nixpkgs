{ stdenv, fetchurl, libGLU_combined, libX11, xproto, tcl, freeglut, freetype
, sfml, libXi, inputproto
, libXmu, libXext, xextproto, libXt, libSM, libICE
, libpng, pkgconfig, gettext, intltool
}:

stdenv.mkDerivation rec {
  version = "0.7.4";
  name = "extremetuxracer-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${version}.tar.xz";
    sha256 = "0d2j4ybdjmimg67v2fndgahgq4fvgz3fpfb3a4l1ar75n6hy776s";
  };

  buildInputs = [
    libGLU_combined libX11 xproto tcl freeglut freetype
    sfml libXi inputproto
    libXmu libXext xextproto libXt libSM libICE
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
    homepage = https://sourceforge.net/projects/extremetuxracer/;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
