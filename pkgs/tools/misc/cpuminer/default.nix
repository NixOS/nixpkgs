{ stdenv, fetchurl, curl, jansson, perl }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "130ab6vcbm9azl9w8n97fzjnjbakm0k2n3wc1bcgy5y5c8s0220h";
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
