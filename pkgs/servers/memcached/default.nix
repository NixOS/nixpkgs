{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation {
  name = "memcached-1.4.15";

  src = fetchurl {
    url = http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz;
    sha256 = "1d7205cp49s379fdy2qz1gz2a5v4nnv18swzmvbascbmgamj35qn";
  };

  buildInputs = [cyrus_sasl libevent];

  meta = {
    description = "A distributed memory object caching system";
    homepage = http://memcached.org/;
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.coconnor ];
  };
}

