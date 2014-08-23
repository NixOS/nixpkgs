
{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-3.2.19";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "12q97cw680hg4rylyd8j3d7azwwia4ndsv3kybd1ajp8hjni39ip";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
