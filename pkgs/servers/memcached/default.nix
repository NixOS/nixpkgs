{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.7";
  name = "memcached-${version}";

  src = fetchurl {
    url = "http://memcached.org/files/${name}.tar.gz";
    sha256 = "0ijfiy1w4hk3j8hhra6kablq8kjabvcdvsl8cwd4drvszjl0ddsv";
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
