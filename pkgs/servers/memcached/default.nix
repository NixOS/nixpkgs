{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  name = "memcached-1.4.20";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "0620llasj8xgffk6hk2ml15z0c5i34455wwg60i1a2zdir023l95";
  };

  buildInputs = [cyrus_sasl libevent];

  meta = {
    description = "A distributed memory object caching system";
    repositories.git = https://github.com/memcached/memcached.git;
    homepage = http://memcached.org/;
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.coconnor ];
    platforms = stdenv.lib.platforms.linux;
  };
}

