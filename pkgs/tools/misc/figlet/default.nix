{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "figlet";
  version = "2.2.5";

  # some tools can be found here ftp://ftp.figlet.org/pub/figlet/util/
  src = fetchurl {
    url = "ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-${version}.tar.gz";
    sha256 = "0za1ax15x7myjl8jz271ybly8ln9kb9zhm1gf6rdlxzhs07w925z";
  };

  patches = [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/figlet/musl-fix-cplusplus-decls.patch?h=3.4-stable&id=71776c73a6f04b6f671430f702bcd40b29d48399";
      name = "musl-fix-cplusplus-decls.patch";
      sha256 = "1720zgrfk9makznqkbjrnlxm7nnhk6zx7g458fv53337n3g3zn7j";
    })
  ];

  makeFlags = [ "prefix=$(out)" "CC:=$(CC)" "LD:=$(CC)" ];

  doCheck = true;

  meta = {
    description = "Program for making large letters out of ordinary text";
    homepage = "http://www.figlet.org/";
    license = lib.licenses.afl21;
    platforms = lib.platforms.unix;
  };
}
