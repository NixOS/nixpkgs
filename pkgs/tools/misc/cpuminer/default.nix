{ stdenv, fetchurl, curl, jansson, perl }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "1xalrfrk5hvh1jh9kbqhib2an82ypd46vl9glaxhz3rbjld7c5pa";
  };

  patchPhase = if stdenv.cc.isClang then "${perl}/bin/perl ./nomacro.pl" else null;

  buildInputs = [ curl jansson ];

  configureFlags = [ "CFLAGS=-O3" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pooler/cpuminer;
    description = "CPU miner for Litecoin and Bitcoin";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
