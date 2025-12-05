{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zigbee2mqtt-networkmap";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "zigbee2mqtt-networkmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S4iUTjI+pFfa8hg1/lJSI1tl2nEIh+LO2WTYhWWLh/s=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-yo+K3vUJH6WwyNj/UuvbhhmhdqzJ3XUzX+cKUueutjE=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/zigbee2mqtt-networkmap.js $out/

    runHook postInstall
  '';

  dontFixup = true;

  passthru.entrypoint = "zigbee2mqtt-networkmap.js";
  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/azuwis/zigbee2mqtt-networkmap/releases/tag/v${finalAttrs.version}";
    description = "Home Assistant Custom Card to show Zigbee2mqtt network map";
    homepage = "https://github.com/azuwis/zigbee2mqtt-networkmap";
    maintainers = with lib.maintainers; [ azuwis ];
    license = lib.licenses.mit;
  };
})
