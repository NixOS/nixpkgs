{ stdenv, fetchurl, cmake, doxygen, zlib, openssl, bzip2, pkgconfig, libpthreadstubs }:

stdenv.mkDerivation rec {
  name = "apt-cacher-ng-${version}";
  version = "0.8.9";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "15zkacy8n6fiklqpdk139pa7qssynrr9akv5h54ky1l53n0k70m6";
  };

  NIX_LDFLAGS = "-lpthread";
  buildInputs = [ doxygen cmake zlib openssl bzip2 pkgconfig libpthreadstubs ];

  meta = {
    description = "A caching proxy specialized for linux distribution files";
    homepage = http://www.unix-ag.uni-kl.de/~bloch/acng/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.makefu ];
  };
}
