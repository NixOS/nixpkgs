{ stdenv, makeWrapper, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "cfr-${version}";
  version = "0.145";

  src = fetchurl {
    url = "http://www.benf.org/other/cfr/cfr_${version}.jar";
    sha256 = "0xv2v9z9xwym5m7h6bkvcmdgsa9lmkvsl77vk3aykgbzxywh7xqv";
  };

  nativeBuildInputs = [ makeWrapper ];

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
