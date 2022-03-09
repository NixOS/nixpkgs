{lib, stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.6.14";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-VNY3QsaIbc3E4Mh/RDmikwqHbNnyv6AdaZsMa60XB7M=";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ]
    ++ lib.optional stdenv.isDarwin "-Wno-error";

  meta = with lib; {
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
