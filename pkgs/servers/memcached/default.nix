{lib, stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.6.27";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-dP4UR8hmit+RD6epKftjWKr0pm73NOdRxbgSgHGw97U=";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  env.NIX_CFLAGS_COMPILE = toString ([ "-Wno-error=deprecated-declarations" ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "-Wno-error");

  meta = with lib; {
    description = "Distributed memory object caching system";
    homepage = "http://memcached.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "memcached";
  };
  passthru.tests = {
    smoke-tests = nixosTests.memcached;
  };
}
