{ stdenv, fetchurl, python, libxml2Python }:

stdenv.mkDerivation rec {
  name = "itstool-1.1.1";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "1jchgcgxvqwkhr61q0j08adl1k8hw86dzbl207gzmns9fa7vmzqg";
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
