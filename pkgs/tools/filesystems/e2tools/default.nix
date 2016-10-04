{ stdenv, fetchurl, pkgconfig, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "e2tools";
  version = "0.0.16";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://home.earthlink.net/~k_sheff/sw/${pname}/${name}.tar.gz";
    sha256 = "16wlc54abqz06dpipjdkw58bncpkxlj5f55lkzy07k3cg0bqwg2f";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ e2fsprogs ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://home.earthlink.net/~k_sheff/sw/e2tools/;
    description = "Utilities to read/write/manipulate files in an ext2/ext3 filesystem";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.leenaars ];
  };
}
