{ stdenv, fetchurl, python2, libxml2Python }:
# We need the same Python as is used to build libxml2Python

stdenv.mkDerivation rec {
  name = "itstool-2.0.4";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "0q7b4qrc758zfx3adsgvz0r93swdbxjr42w37rahngm33nshihlp";
  };

  buildInputs = [ python2 libxml2Python ];

  patchPhase =
    ''
      sed -e '/import libxml2/i import sys\
      sys.path.append("${libxml2Python}/lib/${python2.libPrefix}/site-packages")' \
      -i itstool.in
    '';

  meta = {
    homepage = http://itstool.org/;
    description = "XML to PO and back again";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
