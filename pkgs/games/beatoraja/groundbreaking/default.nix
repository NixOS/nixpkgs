{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "groundbreaking";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gdbg-dev";
    repo = "GdbG_Skin";
    tag = finalAttrs.version;
    hash = "sha256-60ZoUKr2PVDbYhF80Z+OmPfHTbJSAA2NO21Pmh42ifg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja/skin/GroundbreakinG
    cp -r * $out/share/beatoraja/skin/GroundbreakinG

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "beatoraja.pkgs.groundbreaking";
  };

  meta = {
    description = "Skin for beatoraja";
    homepage = "https://github.com/gdbg-dev/GdbG_Skin";
    changelog = "https://github.com/gdbg-dev/GdbG_Skin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfree; # redistribution is prohibited as stated in readme
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
  };
})
