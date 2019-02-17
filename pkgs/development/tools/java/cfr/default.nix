{ stdenv, makeWrapper, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "cfr-${version}";
  version = "0.139";

  src = fetchurl {
    url = "http://www.benf.org/other/cfr/cfr_${version}.jar";
    sha256 = "0wiag1m0hqk697qhrm4c7srzy18ixkcj5dn911lxhf0nfq5q63nk";
  };

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    jar=$out/share/java/cfr_${version}.jar
    install -Dm444 $src $jar
    makeWrapper ${jre}/bin/java $out/bin/cfr --add-flags "-jar $jar"
  '';

  meta = with stdenv.lib; {
    description = "Another java decompiler";
    longDescription = ''
      CFR will decompile modern Java features - Java 8 lambdas (pre and post
      Java beta 103 changes), Java 7 String switches etc, but is written
      entirely in Java 6.
    '';
    homepage = http://www.benf.org/other/cfr/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
