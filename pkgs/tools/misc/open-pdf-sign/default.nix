<<<<<<< HEAD
{ fetchurl
, jre
, lib
, makeBinaryWrapper
, nix-update-script
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.1.6";
  pname = "open-pdf-sign";

  src = fetchurl {
    url = "https://github.com/open-pdf-sign/open-pdf-sign/releases/download/v${finalAttrs.version}/open-pdf-sign.jar";
    hash = "sha256-GpMDgN4P8neHOQsXtg2AKXNeCMnv3nEHH50ZVU0uVvY=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
=======
{ lib, stdenv, fetchurl, makeWrapper, jre, nix-update-script }:

stdenv.mkDerivation rec {
  version = "0.1.4";
  pname = "open-pdf-sign";

  src = fetchurl {
    url = "https://github.com/open-pdf-sign/open-pdf-sign/releases/download/v${version}/open-pdf-sign.jar";
    sha256 = "sha256-tGpjVgG8UcOC0ZFhQ201HvPUyoWso58uM52Vsdwb2lM=";
  };

  nativeBuildInputs = [ makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildCommand = ''
    install -Dm644 $src $out/lib/open-pdf-sign.jar

    mkdir -p $out/bin
<<<<<<< HEAD
    makeWrapper ${lib.getExe jre} $out/bin/open-pdf-sign \
=======
    makeWrapper ${jre}/bin/java $out/bin/open-pdf-sign \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --add-flags "-jar $out/lib/open-pdf-sign.jar"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
=======
  meta = with lib; {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
