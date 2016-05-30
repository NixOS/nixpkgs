{ stdenv, fetchurl
, zlib, curl, gnutls, fribidi, libpng, SDL, SDL_gfx, SDL_image, SDL_mixer
, SDL_net, SDL_ttf, libunwind, libX11, xproto, libxml2, pkgconfig
, gettext, intltool, libtool, perl
}:

stdenv.mkDerivation rec {
  name = "warmux-${version}";
  version = "11.04.1";

  src = fetchurl {
    url = "http://download.gna.org/warmux/${name}.tar.bz2";
    sha256 = "1vp44wdpnb1g6cddmn3nphc543pxsdhjis52mfif0p2c7qslz73q";
  };

  buildInputs =
    [ zlib curl gnutls fribidi libpng SDL SDL_gfx SDL_image SDL_mixer
      SDL_net SDL_ttf libunwind libX11 xproto libxml2 pkgconfig
      gettext intltool libtool perl
    ];

  configureFlagsArray = ("CFLAGS=-include ${zlib.dev}/include/zlib.h");

  patches = [ ./gcc-fix.patch ];

  meta = with stdenv.lib; {
    description = "Ballistics turn-based battle game between teams";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "http://download.gna.org/warmux/";
  };
}
