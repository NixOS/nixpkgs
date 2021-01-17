{ lib, stdenv, fetchurl, pkg-config, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "e2tools";
  version = "0.0.16";

  src = fetchurl {
    url = "http://home.earthlink.net/~k_sheff/sw/${pname}/${pname}-${version}.tar.gz";
    sha256 = "16wlc54abqz06dpipjdkw58bncpkxlj5f55lkzy07k3cg0bqwg2f";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ e2fsprogs ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://home.earthlink.net/~k_sheff/sw/e2tools/";
    description = "Utilities to read/write/manipulate files in an ext2/ext3 filesystem";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.leenaars ];
  };
}
