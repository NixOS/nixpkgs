{ lib, stdenv, fetchzip
, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "epubcheck";
  version = "4.2.6";

  src = fetchzip {
    url = "https://github.com/w3c/epubcheck/releases/download/v${version}/epubcheck-${version}.zip";
    sha256 = "sha256-f4r0ODKvZrl+YBcP2T9Z+zEuCyvQm9W7GNiLTr4p278=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    cp -r lib/* $out/lib

    mkdir -p $out/libexec/epubcheck
    cp epubcheck.jar $out/libexec/epubcheck

    classpath=$out/libexec/epubcheck/epubcheck.jar
    for jar in $out/lib/*.jar; do
      classpath="$classpath:$jar"
    done

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/epubcheck \
      --add-flags "-classpath $classpath com.adobe.epubcheck.tool.Checker"
  '';

  meta = with lib; {
    homepage = "https://github.com/w3c/epubcheck";
    description = "Validation tool for EPUB";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [ asl20 bsd3 mpl10 w3c ];
    platforms = platforms.all;
    maintainers = with maintainers; [ eadwu ];
  };
}
