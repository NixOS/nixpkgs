{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  name = "memcached-1.4.17";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha1 = "2b4fc706d39579cf355e3358cfd27b44d40bd79c";
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

