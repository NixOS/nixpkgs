{ stdenv, fetchurl, libGLU_combined, libX11, xorgproto, tcl, freeglut, freetype
, sfml, libXi
, libXmu, libXext, libXt, libSM, libICE
, libpng, pkgconfig, gettext, intltool
}:

stdenv.mkDerivation rec {
  version = "0.7.5";
  name = "extremetuxracer-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${version}.tar.xz";
    sha256 = "1ly63316c07i0gyqqmyzsyvygsvygn0fpk3bnbg25fi6li99rlsg";
  };

  buildInputs = [
    libGLU_combined libX11 xorgproto tcl freeglut freetype
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
    homepage = https://sourceforge.net/projects/extremetuxracer/;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
