{stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.6.8";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "0fbrrn7mkhv5xci4cffxxb8qzr9c0n3y58jymq2aqlpzyq8klfz2";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-Wno-error";

  meta = with stdenv.lib; {
    description = "A distributed memory object caching system";
    repositories.git = "https://github.com/memcached/memcached.git";
    homepage = "http://memcached.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
  passthru.tests = {
    smoke-tests = nixosTests.memcached;
  };
}
