{ stdenv, fetchurl, cmake, doxygen, zlib, openssl, bzip2, pkgconfig, libpthreadstubs }:

stdenv.mkDerivation rec {
  name = "apt-cacher-ng-${version}";
  version = "0.8.6";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "0044dfks8djl11fs28jj8894i4rq424xix3d3fkvzz2i6lnp8nr5";
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
