{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minir";
  version = "600";

  src = fetchzip {
    url = "https://drive.usercontent.google.com/download?export=download&confirm=t&id=1wYVNufrfiVAWUkYTVdGl0Q0PqrhkHZBo";
    extension = "zip";
    stripRoot = false;
    hash = "sha256-ByvYbjRJ4wh3UPR7/yQ+pMOHmyotmOwoNvEylER5Kr4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 minir-${finalAttrs.version}.jar $out/share/beatoraja/ir/minir.jar

    runHook postInstall
  '';

  meta = {
    description = "IR designed for beatoraja";
    homepage = "https://www.gaftalk.com/minir";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
