{ stdenv, fetchurl, pkgconfig, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "xmlstarlet-1.6.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/xmlstar/${name}.tar.gz";
    sha256 = "1jp737nvfcf6wyb54fla868yrr39kcbijijmjpyk4lrpyg23in0m";
  };

  buildInputs = [ pkgconfig libxml2 libxslt ];

  preConfigure =
    ''
      export LIBXSLT_PREFIX=${libxslt.dev}
      export LIBXML_PREFIX=${libxml2}
      export LIBXSLT_LIBS=$(pkg-config --libs libxslt libexslt)
      export LIBXML_LIBS=$(pkg-config --libs libxml-2.0)
    '';

  postInstall =
    ''
      ln -s xml $out/bin/xmlstarlet
    '';

  meta = {
    description = "A command line tool for manipulating and querying XML data";
    homepage = http://xmlstar.sourceforge.net/;
    license = stdenv.lib.licenses.mit;
  };
}
