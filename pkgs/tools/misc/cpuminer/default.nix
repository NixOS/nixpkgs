{ stdenv, fetchurl, curl, jansson }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "0xdgz5qlx1yr3mw2h4bwlbj94y6v2ygjy334cnc87xgzxf1wgann";
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
