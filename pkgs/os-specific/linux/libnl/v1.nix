{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-1.1";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "1hzd48z8h8abkclq90wb7cciynpg3pwgyd0gzb5g12ndnv7s9kim";
  };

  buildInputs = [ bison flex ];
  postConfigure = "type -tp flex";

  patches = [
    ./libnl-1.1-flags.patch
    ./libnl-1.1-glibc-2.8-ULONG_MAX.patch
    ./libnl-1.1-minor-leaks.patch
    ./libnl-1.1-vlan-header.patch
  ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
