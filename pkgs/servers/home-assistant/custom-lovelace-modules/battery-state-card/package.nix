{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "battery-state-card";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "maxwroc";
    repo = "battery-state-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/oFW80zCp4vnRc3ZKVJtvNH11UPrdustFDktZdnFiQM=";
  };

  npmDepsHash = "sha256-TYiUTzNsaEwy9Y5O0UyFXCGFJ/jdjTek3B5CVvac+p8=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  installPhase = ''
    runHook preInstall

    install ./dist/battery-state-card.js -Dt $out

    runHook postInstall
  '';

  meta = {
    description = "Battery state card for Home Assistant";
    homepage = "https://github.com/maxwroc/battery-state-card";
    changelog = "https://github.com/maxwroc/battery-state-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
