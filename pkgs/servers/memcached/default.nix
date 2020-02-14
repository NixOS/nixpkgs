{stdenv, fetchurl, fetchpatch, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.22";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "14qzbxgz40j4yhi3lzrsdjd6kyy3zwv9c8kw11kj6njp42fpxd62";
  };

  patches = [
    # Fixes compilation error on Darwin due to redeclaration of
    # htonll. The fix should appear in 1.5.23.
    # https://github.com/memcached/memcached/issues/598
    (fetchpatch {
      url = "https://github.com/memcached/memcached/commit/95c67710aaf5cfe188d94b510faef8c66d6f5604.diff";
      sha256 = "0ab5l24p4n4fpx78ilmg7jvs9nl84pdza90jbpbx3ns5n23pqbfs";
    })
  ];

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
