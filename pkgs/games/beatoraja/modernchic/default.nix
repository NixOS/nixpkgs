{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "modernchic";
  version = "4.6.0";

  src = fetchzip {
    url = "https://drive.usercontent.google.com/download?export=download&confirm=t&id=1GiZ1EDb_BdHFUXgqkHBzmkjYiQv3YLEx";
    extension = "zip";
    hash = "sha256-AJH1xVNb2s/BEBBu01qV8tyJctBftqJ4wG7H5NlGTIw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja/skin/ModernChic
    cp -r * $out/share/beatoraja/skin/ModernChic

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "ModernChic skin for beatoraja";
    homepage = "https://www.kasacontent.com/tag/modernchic";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
  };
})
