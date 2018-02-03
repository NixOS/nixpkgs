{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.4";
  name = "memcached-${version}";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "1m03fhzq1f9byk2agccsr0x458niqqjpips5mbcgzhm4kylczhz0";
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
