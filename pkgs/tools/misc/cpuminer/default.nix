{ stdenv, fetchurl, curl, jansson }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "0yl3ca31ck732f4551svxw6lx1lrjr7rhld5v09v0bgm3z07nnrx";
  };

  buildInputs = [ curl jansson ];

  configureFlags = [ "CFLAGS=-O3" ];

  meta = {
    homepage = https://github.com/pooler/cpuminer;
    description = "CPU miner for Litecoin and Bitcoin";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
