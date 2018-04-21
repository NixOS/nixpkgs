{ stdenv
, bzip2
, cmake
, doxygen
, fetchurl
, fuse
, lzma
, openssl
, pkgconfig
, systemd
, tcp_wrappers
, zlib
}:

stdenv.mkDerivation rec {
  name = "apt-cacher-ng-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "0p8cdig70vz1dgw2v8brjin5wqrk8amncphyf11f53bza5grlc91";
  };

  nativeBuildInputs = [ cmake doxygen pkgconfig ];
  buildInputs = [ bzip2 fuse lzma openssl systemd tcp_wrappers zlib ];

  meta = with stdenv.lib; {
    description = "A caching proxy specialized for linux distribution files";
    homepage = https://www.unix-ag.uni-kl.de/~bloch/acng/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
