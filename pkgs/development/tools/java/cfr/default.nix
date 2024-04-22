{ lib, stdenv, makeWrapper, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "cfr";
  version = "0.152";

  src = fetchurl {
    url = "http://www.benf.org/other/cfr/cfr_${version}.jar";
    sha256 = "sha256-9obo897Td9e8h9IWqQ6elRLfQVbnWwbGVaFmSK6HZbI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    jar=$out/share/java/cfr_${version}.jar
    install -Dm444 $src $jar
    makeWrapper ${jre}/bin/java $out/bin/cfr --add-flags "-jar $jar"
  '';

  meta = with lib; {
    description = "Another java decompiler";
    mainProgram = "cfr";
    longDescription = ''
      CFR will decompile modern Java features - Java 8 lambdas (pre and post
      Java beta 103 changes), Java 7 String switches etc, but is written
      entirely in Java 6.
    '';
    homepage = "http://www.benf.org/other/cfr/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
