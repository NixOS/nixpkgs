{ stdenv, fetchurl, pkgconfig, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "xmlstarlet-1.5.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/xmlstar/${name}.tar.gz";
    sha256 = "1fmvqvzrzyfcg53j39sdz01v7klzyhd011m3y9br54525q2fvd27";
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
