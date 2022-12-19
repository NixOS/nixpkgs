{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  pname = "open-pdf-sign";

  src = fetchurl {
    url = "https://github.com/open-pdf-sign/open-pdf-sign/releases/download/v${version}/open-pdf-sign.jar";
    sha256 = "AfxpqDLIycXMQmYexRoFh5DD/UCBHrnGSMjfjljvKs4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm644 $src $out/lib/open-pdf-sign.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/open-pdf-sign \
      --add-flags "-jar $out/lib/open-pdf-sign.jar"
  '';

  meta = with lib; {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol ];
    platforms = platforms.unix;
  };
}
