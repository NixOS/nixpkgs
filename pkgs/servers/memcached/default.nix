{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation {
  name = "memcached-1.4.13";

  src = fetchurl {
    url = http://memcached.googlecode.com/files/memcached-1.4.13.tar.gz;
    sha256 = "0abyy9agjinac56bb1881j3qs6xny7r12slh4wihv2apma3qn2yb";
  };

  buildInputs = [cyrus_sasl libevent];

  meta = {
    description = "A distributed memory object caching system";
    homepage = http://memcached.org/;
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.coconnor ];
  };
}

