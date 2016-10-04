{ stdenv, fetchurl, python, libxml2Python }:

stdenv.mkDerivation rec {
  name = "itstool-2.0.2";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a";
  };

  buildInputs = [ python libxml2Python ];

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
