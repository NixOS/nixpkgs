{lib, stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.6.21";
=======
  version = "1.6.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-x4iYDvxBfdXZPEQrHIuHafsgGIlsKd44h9IqLxQ9ou4=";
=======
    sha256 = "sha256-L9SLBHFGOYsHOliOl5F9m8kIzlGXhYDY4L7aoSO0xw0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  env.NIX_CFLAGS_COMPILE = toString ([ "-Wno-error=deprecated-declarations" ]
    ++ lib.optional stdenv.isDarwin "-Wno-error");

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
