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
, c-ares
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.7.4";

  src = fetchurl {
    url = "https://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "0pwsj9rf6a6q7cnfbpcrfq2gjcy7sylqzqqr49g2zi39lrrh8533";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];
  buildInputs = [ bzip2 fuse libevent xz openssl systemd tcp_wrappers zlib c-ares ];

  meta = with lib; {
    description = "A caching proxy specialized for Linux distribution files";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
