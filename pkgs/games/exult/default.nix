{stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng}:

stdenv.mkDerivation {
  name = "exult-1.2";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/exult/exult-1.2.tar.gz;
    md5 = "0fc88dee74a91724d25373ba0a8670ba";
  };
  buildInputs = [SDL SDL_mixer zlib libpng];
#  patches = [./gcc4.patch];
  NIX_CFLAGS_COMPILE = "-I${SDL_mixer}/include/SDL";
}
