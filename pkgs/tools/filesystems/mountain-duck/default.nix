{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mountain-duck";
  version = "4.14.1.21330";

  src = fetchurl {
    url = "https://dist.mountainduck.io/Mountain%20Duck-${finalAttrs.version}.zip";
    sha256 = "0wcnqwzrhzgjpm7pqzbn4fbnwc5rnmw56gma0a1961d5j9vqcs49";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mount server and cloud storage as a disk on macOS and Windows";
    homepage = "https://mountainduck.io";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      Enzime
    ];
    platforms = platforms.darwin;
  };
})
