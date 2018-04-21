{ stdenv, makeWrapper, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "cfr-${version}";
  version = "0_125";

  src = fetchurl {
    url = "http://www.benf.org/other/cfr/cfr_${version}.jar";
    sha256 = "1ad9ddg79cybv8j8l3mm67znyw54z5i55x4m9n239fn26p1ndawa";
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
