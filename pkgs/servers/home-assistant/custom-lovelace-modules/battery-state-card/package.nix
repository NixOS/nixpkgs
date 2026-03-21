{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "battery-state-card";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "maxwroc";
    repo = "battery-state-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwyOdNlGMHK1xrwRL85R0i5s9g5I44WjHcbNTAY/fkw=";
  };

  npmDepsHash = "sha256-vhjH7AePShgrzLRgCEn5sO0jJzOstDzMDQaog2UCarM=";

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
