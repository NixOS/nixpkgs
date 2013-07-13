{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "byacc-1.9";

  src = fetchurl {
    url = http://invisible-island.net/datafiles/release/byacc.tar.gz;
    sha256 = "1ifiipq6nprd9mcnlnmrg9iskh1v73637k3nx4lcazqaamiliyjs";
  };

  preConfigure =
    ''mkdir -p $out/bin
      #sed -i "s@^DEST.*\$@DEST = $out/bin/yacc@" Makefile
    '';
  postInstall = "mv $out/bin/yacc $out/bin/byacc";

  meta = { 
    description = "Berkeley YACC";
    homepage = http://dickey.his.com/byacc/byacc.html;
    license = "public domain";
  };
}
