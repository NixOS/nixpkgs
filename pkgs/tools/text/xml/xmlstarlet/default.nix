{ lib, stdenv, fetchurl, pkg-config, libxml2, libxslt }:

stdenv.mkDerivation rec {
  pname = "xmlstarlet";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/xmlstar/xmlstarlet-${version}.tar.gz";
    sha256 = "1jp737nvfcf6wyb54fla868yrr39kcbijijmjpyk4lrpyg23in0m";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 libxslt ];

  preConfigure =
    ''
      export LIBXSLT_PREFIX=${libxslt.dev}
      export LIBXML_PREFIX=${libxml2.dev}
      export LIBXSLT_LIBS=$(pkg-config --libs libxslt libexslt)
      export LIBXML_LIBS=$(pkg-config --libs libxml-2.0)
    '';

  postInstall =
    ''
      ln -s xml $out/bin/xmlstarlet
    '';

  meta = {
    description = "A command line tool for manipulating and querying XML data";
    homepage = "https://xmlstar.sourceforge.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
