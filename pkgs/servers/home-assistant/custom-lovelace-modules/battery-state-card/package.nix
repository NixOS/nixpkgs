{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "battery-state-card";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "maxwroc";
    repo = "battery-state-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qjpPdF3+dwVHr2u9UyU51WlJtok5Ogo8sjRr7wm4P4w=";
  };

  npmDepsHash = "sha256-BiTi81obyKV6PR9y+ZD0+jAepi24zTYXbBlbNXUUTwk=";

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
