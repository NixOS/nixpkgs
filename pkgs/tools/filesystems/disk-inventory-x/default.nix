{ lib
, stdenvNoCC
, fetchurl
, undmg
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "disk-inventory-x";
  version = "1.3";

  src = fetchurl {
    url = "https://www.derlien.com/diskinventoryx/downloads/Disk%20Inventory%20X%20${finalAttrs.version}.dmg";
    sha256 = "1rfqp8ia6ficvqxynn43f1pba4rfmhf61kn2ihysbnjs8c33bbvq";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Disk usage utility for Mac OS X";
    homepage = "https://www.derlien.com";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = [ "x86_64-darwin" ];
  };
})
