{stdenv, fetchgit
, zlib, jam, pkgconfig, gettext, libxml2, libxslt, xproto, libX11, mesa, SDL
, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, physfs, autoconf, automake, libtool
}:
stdenv.mkDerivation rec {
  name = "lincity-ng-${version}";
  version = "2.9beta.20170715";

  src = fetchgit {
    url = "https://github.com/lincity-ng/lincity-ng";
    rev = "0c19714b811225238f310633e59f428934185e6b";
    sha256 = "1gaj9fq97zmb0jsdw4rzrw34pimkmkwbfqps0glpqij4w3srz5f3";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    jam autoconf automake libtool pkgconfig
  ];

  buildInputs = [
    zlib gettext libxml2 libxslt xproto libX11 mesa SDL SDL_mixer SDL_image
    SDL_ttf SDL_gfx physfs
  ];

   preConfigure = ''
     ./autogen.sh
   '';

   installPhase = ''
     touch CREDITS
     AR='ar r' jam install
   '';

  meta = {
    description = ''City building game'';
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
