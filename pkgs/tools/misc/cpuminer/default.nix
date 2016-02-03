{ stdenv, fetchurl, curl, jansson }:

stdenv.mkDerivation rec {
  name = "cpuminer-${version}";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/cpuminer/pooler-${name}.tar.gz";
    sha256 = "1p66v96pz3vk1khwlmc26fg2d06c001755rrkcdv5wh8zyg6wv99";
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
