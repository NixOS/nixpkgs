{ stdenv, fetchurl, python, libxml2Python }:

stdenv.mkDerivation rec {
  name = "itstool-1.2.0";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "1akq75aflihm3y7js8biy7b5mw2g11vl8yq90gydnwlwp0zxdzj6";
  };

  buildInputs = [ python ];

  patchPhase =
    ''
      sed -e '/import libxml2/i import sys\
      sys.path.append("${libxml2Python}/lib/${python.libPrefix}/site-packages")' \
      -i itstool.in
    '';

  meta = {
    homepage = http://itstool.org/;
    description = "XML to PO and back again";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
