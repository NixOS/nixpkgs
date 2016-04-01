{ stdenv, fetchurl, cmake, doxygen, zlib, openssl, bzip2, pkgconfig, libpthreadstubs }:

stdenv.mkDerivation rec {
  name = "apt-cacher-ng-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "1d686knvig1niapc1ib2045f7jfad3m4jvz6gkwm276fqvm4p694";
  };

  NIX_LDFLAGS = "-lpthread";
  nativeBuildInputs = [ cmake doxygen pkgconfig ];
  buildInputs = [ zlib openssl bzip2 libpthreadstubs ];

  meta = with stdenv.lib; {
    description = "A caching proxy specialized for linux distribution files";
    homepage = https://www.unix-ag.uni-kl.de/~bloch/acng/;
    license = licenses.gpl2;
    maintainers = [ maintainers.makefu ];
  };
}
