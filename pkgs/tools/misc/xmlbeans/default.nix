{ lib, stdenv, fetchzip, jre_headless }:

stdenv.mkDerivation rec {
  pname = "xmlbeans";
  version = "5.0.2-20211014";

  src = fetchzip {
    url = "https://dlcdn.apache.org/poi/xmlbeans/release/bin/xmlbeans-bin-${version}.zip";
    sha256 = "sha256-1o0kfBMhka/Midtg+GzpVDDygixL6mrfxtY5WrjLN+0=";
  };

  postPatch = ''
    rm bin/*.cmd
    substituteInPlace bin/dumpxsb \
      --replace 'echo `dirname $0`' ""

    substituteInPlace bin/_setlib \
      --replace 'echo XMLBEANS_LIB=$XMLBEANS_LIB' ""

    for file in bin/*; do
      substituteInPlace $file \
        --replace "java " "${jre_headless}/bin/java "
    done
  '';

  installPhase = ''
    mkdir -p $out
    chmod +x bin/*
    cp -r bin/ lib/ $out/
  '';

  meta = with lib; {
    description = "Java library for accessing XML by binding it to Java types";
    homepage = "https://xmlbeans.apache.org/";
    downloadPage = "https://dlcdn.apache.org/poi/xmlbeans/release/bin/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
