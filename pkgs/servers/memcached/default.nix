{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  name = "memcached-1.4.20";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "0620llasj8xgffk6hk2ml15z0c5i34455wwg60i1a2zdir023l95";
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
