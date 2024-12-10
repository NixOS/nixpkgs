{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "xmlstarlet";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/xmlstar/xmlstarlet-${version}.tar.gz";
    sha256 = "1jp737nvfcf6wyb54fla868yrr39kcbijijmjpyk4lrpyg23in0m";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libxml2
    libxslt
  ];

  patches = [
    (fetchpatch {
      name = "0001-Fix-build-with-libxml2-2.12.patch";
      url = "https://sourceforge.net/p/xmlstar/patches/_discuss/thread/890e29655a/66ca/attachment/0001-Fix-build-with-libxml2-2.12.patch";
      hash = "sha256-XEk7aFOdrzdec1j2ffERJQbLH0AUNJA52QwA9jf4XWA=";
    })
  ];

  preConfigure = ''
    export LIBXSLT_PREFIX=${libxslt.dev}
    export LIBXML_PREFIX=${libxml2.dev}
    export LIBXSLT_LIBS=$($PKG_CONFIG --libs libxslt libexslt)
    export LIBXML_LIBS=$($PKG_CONFIG --libs libxml-2.0)
  '';

  postInstall = ''
    ln -s xml $out/bin/xmlstarlet
  '';

  meta = {
    description = "A command line tool for manipulating and querying XML data";
    homepage = "https://xmlstar.sourceforge.net/";
    license = lib.licenses.mit;
    mainProgram = "xmlstarlet";
    platforms = lib.platforms.unix;
  };
}
