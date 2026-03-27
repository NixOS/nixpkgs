{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "beatoraja-bin";
  version = "0.8.8";

  src = fetchzip {
    url = "https://mocha-repository.info/download/beatoraja${finalAttrs.version}-modernchic.zip";
    hash = "sha256-TujfJ7hgjEKs5NbGvwo3/nkbJFvcZ4mefgkdp6oQHw4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    cp -r * $out/share/beatoraja
    rm $out/share/beatoraja/*.{bat,dll,command}
    rm -r $out/share/beatoraja/{manual,ir}
    rm -r $out/share/beatoraja/{bgm,sound,skin}/ModernChic

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform rhythm game based on Java and libGDX";
    homepage = "https://mocha-repository.info";
    downloadPage = "https://mocha-repository.info/download.php";
    license = with lib.licenses; [
      gpl3Only
      unfree # mocha IR
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
})
