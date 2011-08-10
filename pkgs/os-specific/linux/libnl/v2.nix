{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-2.0";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "173sr25xpsakdvjcg62790v6kwcgxj5r0js2lx6hg89w7n8dqh2s";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
