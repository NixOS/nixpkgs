{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  name = "memcached-1.4.39";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "0dfpmx0fqgp55j4vl06cz63fwx5kzhzipdm7n2kxjkvyg1ybzi13";
  };

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-Wno-error";

  meta = with stdenv.lib; {
    description = "A distributed memory object caching system";
    repositories.git = https://github.com/memcached/memcached.git;
    homepage = http://memcached.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
