{ lib, stdenv
, bzip2
, cmake
, doxygen
, fetchurl
, fuse
, libevent
, lzma
, openssl
, pkg-config
, systemd
, tcp_wrappers
, zlib
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.6";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "sha256-/4jA5acNpHpdQ9kb/1A9thtoUCqsYFxSCr4JLmFYdt4=";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];
  buildInputs = [ bzip2 fuse libevent lzma openssl systemd tcp_wrappers zlib ];

  meta = with lib; {
    description = "A caching proxy specialized for linux distribution files";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
