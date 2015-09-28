{ stdenv, fetchurl, curl, jansson }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "1ds5yfxf25pd8y5z5gh689qb80m4dqw2dy3yx87hibnprlaiym0n";
  };

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
