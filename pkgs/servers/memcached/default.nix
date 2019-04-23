{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.13";
  name = "memcached-${version}";

  src = fetchurl {
    url = "https://memcached.org/files/${name}.tar.gz";
    sha256 = "0qsdkjrns4f02lmabq8c7mzl5n4382q2p6a0dvmsjdcpjisagqb1";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

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
