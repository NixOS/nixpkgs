{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, bison, flex, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libnl-${version}";
  version = "3.4.0";

  src = fetchFromGitHub {
    repo = "libnl";
    owner = "thom311";
    rev = "libnl${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1bqf1f5glwf285sa98k5pkj9gg79lliixk1jk85j63v5510fbagp";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/musl/48d2a28710ae40877fd3e178ead1fb1bb0baa62c/dev-libs/libnl/files/libnl-3.3.0_rc1-musl.patch";
      sha256 = "0dd7xxikib201i99k2if066hh7gwf2i4ffckrjplq6lr206jn00r";
    });

  enableParallelBuilding = true;

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
