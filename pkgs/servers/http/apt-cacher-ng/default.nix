{ lib, stdenv
, bzip2
, cmake
, doxygen
, fetchurl
, fuse
, libevent
, xz
, openssl
, pkg-config
, systemd
, tcp_wrappers
, zlib
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.6.3";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "sha256-P4ArWpxjOjBi9EiDp/ord17GfUOFwpiTKGvSEuZljGA=";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];
  buildInputs = [ bzip2 fuse libevent xz openssl systemd tcp_wrappers zlib ];

  meta = with lib; {
    description = "A caching proxy specialized for linux distribution files";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
