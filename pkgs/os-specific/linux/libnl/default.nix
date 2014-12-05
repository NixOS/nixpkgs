{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-3.2.25";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "1icfrv8yihcb74as1gcgmp0wfpdq632q2zvbvqqvjms9cy87bswb";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
