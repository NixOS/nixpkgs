{ stdenv, fetchurl, curl, jansson }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "0grj0swh1q3c3bj3yxji80yhxb09yz62x1n5h8z7c3azq4rrv2w1";
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
