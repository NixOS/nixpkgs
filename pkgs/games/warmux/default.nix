{ stdenv, fetchFromGitHub, autoconf, automake
, zlib, curl, gnutls, fribidi, libpng, SDL, SDL_gfx, SDL_image, SDL_mixer
, SDL_net, SDL_ttf, libunwind, libX11, xorgproto, libxml2, pkgconfig
, gettext, intltool, libtool, perl
}:

stdenv.mkDerivation rec {
  name = "warmux-${version}";
  version = "unstable-2017-10-20";

  src = fetchFromGitHub {
    owner = "fluxer";
    repo = "warmux";
    rev = "8f81d4fc309a548ae89a068c2dde27b7e7ef8851";
    sha256 = "1hvzglsmp75xiqqb0k75qjz4jwi8kl3fhn8zfsz53hhhqmbw6wkr";
  };

  preConfigure = "patchShebangs autogen.sh && ./autogen.sh";
  configureFlagsArray = ("CFLAGS=-include ${zlib.dev}/include/zlib.h");

  nativeBuildInputs = [
    autoconf automake gettext intltool libtool pkgconfig
  ];
  buildInputs = [
    zlib curl gnutls fribidi libpng SDL SDL_gfx SDL_image SDL_mixer
    SDL_net SDL_ttf libunwind libX11 xorgproto libxml2 perl
  ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Ballistics turn-based battle game between teams - unofficial copy";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 ufl ];
    homepage = https://github.com/fluxer/warmux;
  };
}
