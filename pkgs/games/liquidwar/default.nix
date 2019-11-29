{ stdenv, fetchurl, xorgproto, libX11, libXrender
, gmp, libjpeg, libpng
, expat, gettext, perl, guile
, SDL, SDL_image, SDL_mixer, SDL_ttf
, curl, sqlite, libtool, readline
, libogg, libvorbis, libcaca, csound, cunit } :

stdenv.mkDerivation rec {
  pname = "liquidwar6";
  version = "0.6.3902";

  src = fetchurl {
    url = "mirror://gnu/liquidwar6/${pname}-${version}.tar.gz";
    sha256 = "1976nnl83d8wspjhb5d5ivdvdxgb8lp34wp54jal60z4zad581fn";
  };

  buildInputs = [
    xorgproto libX11 gmp guile
    libjpeg libpng
    expat gettext perl
    SDL SDL_image SDL_mixer SDL_ttf
    curl sqlite
    libogg libvorbis csound
    libXrender libcaca cunit
    libtool readline
  ];

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE =
    "-Wno-error=deprecated-declarations" +
    # Avoid GL_GLEXT_VERSION double definition
    " -DNO_SDL_GLEXT"
  ;

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
