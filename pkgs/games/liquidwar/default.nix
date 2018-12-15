{ stdenv, fetchurl, xproto, libX11, libXrender
, gmp, libGLU_combined, libjpeg, libpng
, expat, gettext, perl, guile
, SDL, SDL_image, SDL_mixer, SDL_ttf
, curl, sqlite, libtool, readline
, libogg, libvorbis, libcaca, csound, cunit } :

stdenv.mkDerivation rec {
  name = "liquidwar6-${version}";
  version = "0.6.3902";

  src = fetchurl {
    url = "mirror://gnu/liquidwar6/${name}.tar.gz";
    sha256 = "1976nnl83d8wspjhb5d5ivdvdxgb8lp34wp54jal60z4zad581fn";
  };

  buildInputs = [
    xproto libX11 gmp guile
    libGLU_combined libjpeg libpng
    expat gettext perl
    SDL SDL_image SDL_mixer SDL_ttf
    curl sqlite
    libogg libvorbis csound
    libXrender libcaca cunit
    libtool readline
  ];

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # To avoid problems finding SDL_types.h.
  configureFlags = [ "CFLAGS=-I${SDL.dev}/include/SDL" ];

  meta = with stdenv.lib; {
    description = "Quick tactics game";
    homepage = https://www.gnu.org/software/liquidwar6/;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
