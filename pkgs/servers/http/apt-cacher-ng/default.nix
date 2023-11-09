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
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.7.4";

  src = fetchurl {
    url = "https://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "sha256-YxQEc6ZpxC9eIhnjj6nXxzP5BHaZ3eUsO9go43KSml8=";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];
  buildInputs = [ bzip2 fuse libevent xz openssl systemd tcp_wrappers zlib c-ares ];
  patches = [
    ( fetchpatch {
      name = "Adjust HAVE_STRLCPY macro with glib 2.38";
      url = "https://git.launchpad.net/ubuntu/+source/apt-cacher-ng/plain/debian/patches/0001-Adjust-HAVE_STRLCPY-macro-check.patch";
      sha256 = "sha256-uhQj+ZcHCV36Tm0pF/+JG59bSaRdTZCrMcKL3YhZTk8=";
    })
  ];
  meta = with lib; {
    description = "A caching proxy specialized for Linux distribution files";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
