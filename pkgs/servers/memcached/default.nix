{lib, stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.6.17";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-IFXjc2E9j8IVKa/58K3OPiO5zgG6BHjTDnlB2fK9EiQ=";
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
    homepage = "http://memcached.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
  passthru.tests = {
    smoke-tests = nixosTests.memcached;
  };
}
