{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  libX11,
  xorgproto,
  tcl,
  freeglut,
  freetype,
  sfml,
  libXi,
  libXmu,
  libXext,
  libXt,
  libSM,
  libICE,
  libpng,
  pkg-config,
  gettext,
  intltool,
}:

stdenv.mkDerivation rec {
  version = "0.8.4";
  pname = "extremetuxracer";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${version}.tar.xz";
    sha256 = "sha256-+jKFzAx1Wlr/Up8/LOo1FkgRFMa0uOHsB2n+7/BHc+U=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    libGLU
    libGL
    libX11
    xorgproto
    tcl
    freeglut
    freetype
    sfml
    libXi
    libXmu
    libXext
    libXt
    libSM
    libICE
    libpng
    gettext
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
    license = lib.licenses.gpl2Plus;
    homepage = "https://sourceforge.net/projects/extremetuxracer/";
    maintainers = with lib.maintainers; [ ];
    mainProgram = "etr";
    platforms = with lib.platforms; linux;
  };
}
