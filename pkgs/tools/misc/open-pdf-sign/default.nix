{ lib, stdenv, fetchurl, makeWrapper, jre, nix-update-script }:

stdenv.mkDerivation rec {
  version = "0.1.1";
  pname = "open-pdf-sign";

  src = fetchurl {
    url = "https://github.com/open-pdf-sign/open-pdf-sign/releases/download/v${version}/open-pdf-sign.jar";
    sha256 = "sha256-n8ua/wUz/PquB7viaFqBu2XX1KQYago4s6JUwYRLvNA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm644 $src $out/lib/open-pdf-sign.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/open-pdf-sign \
      --add-flags "-jar $out/lib/open-pdf-sign.jar"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol ];
    platforms = platforms.unix;
  };
}
