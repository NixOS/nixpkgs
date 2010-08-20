{ stdenv, fetchurl, pkgconfig, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "xmlstarlet-1.0.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/xmlstar/${name}.tar.gz";
    sha256 = "07a5c3fhqpvyy07pggl3ky7ahvlcpsmppy71x4h4albvanfbpjwj";
  };

  buildInputs = [ pkgconfig libxml2 libxslt ];

  preConfigure =
    ''
      export LIBXSLT_PREFIX=${libxslt}
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
    license = "bsd";
  };
}
