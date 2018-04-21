{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, bison, flex, pkgconfig }:

let version = "3.3.0"; in
stdenv.mkDerivation {
  name = "libnl-${version}";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1796kyq2lkhz2802v9kp32vlxf8ynlyqgyw9nhmry3qh5d0ahcsv";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/musl/48d2a28710ae40877fd3e178ead1fb1bb0baa62c/dev-libs/libnl/files/libnl-3.3.0_rc1-musl.patch";
      sha256 = "0dd7xxikib201i99k2if066hh7gwf2i4ffckrjplq6lr206jn00r";
    });

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig ];

  meta = with lib; {
    inherit version;
    homepage = http://www.infradead.org/~tgr/libnl/;
    description = "Linux Netlink interface library suite";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
