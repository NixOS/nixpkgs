{ stdenv
, bzip2
, cmake
, doxygen
, fetchurl
, fuse
, libevent
, lzma
, openssl
, pkgconfig
, systemd
, tcp_wrappers
, zlib
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.5";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "0h76n02nnpg7ir9247qrxb8p4d4p282nh13zrv5bb9sfm12pril2";
  };

  nativeBuildInputs = [ cmake doxygen pkgconfig ];
  buildInputs = [ bzip2 fuse libevent lzma openssl systemd tcp_wrappers zlib ];

  meta = with stdenv.lib; {
    description = "A caching proxy specialized for linux distribution files";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
