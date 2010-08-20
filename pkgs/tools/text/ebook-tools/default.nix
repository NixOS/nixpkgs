{ stdenv, fetchurl, cmake, libxml2, libzip }:

let
  pn = "ebook-tools";
in

stdenv.mkDerivation rec {
  name = "${pn}-0.1.1";

  src = fetchurl {
    url = "mirror://sf/${pn}/${name}.tar.gz";
    sha256 = "07flqm0c252jklggjmg998qzyvwlw67c3db2jbg734figngrjh79";
  };

  buildInputs = [ cmake libxml2 libzip ];

  meta = {
    homepage = "http://${pn}.sourceforge.net";
    description = "Tools and libs for dealing with various ebook file formats";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
