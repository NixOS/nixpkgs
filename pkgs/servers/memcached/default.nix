{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.6";
  name = "memcached-${version}";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "00szy9d4szaixi260dcd4846zci04y0sd47ia2lzg0bxkn2ywxcn";
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
