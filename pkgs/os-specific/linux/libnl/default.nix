{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-3.0";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "1vac10m3w0m5lsypjcrhs2dzwng82nkbzqz8g8kyzkxb3qz5ql3s";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
