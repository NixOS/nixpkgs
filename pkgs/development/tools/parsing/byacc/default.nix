{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "byacc-1.9";

  src = fetchurl {
    url = http://www.isc.org/sources/devel/tools/byacc-1.9.tar.gz;
    sha256 = "d61a15ac4ac007c188d0c0e99365f016f8d327755f43032b58e400754846f736";
  };

  preConfigure =
    ''mkdir -p $out/bin
      sed -i "s@^DEST.*\$@DEST = $out/bin/yacc@" Makefile
    '';

  meta = { 
    description = "Berkeley YACC";
    homepage = http://dickey.his.com/byacc/byacc.html;
    license = "public domain";
  };
}
