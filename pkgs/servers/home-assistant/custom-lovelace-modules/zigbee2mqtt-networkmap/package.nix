{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
}:

mkYarnPackage rec {
  pname = "zigbee2mqtt-networkmap";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "zigbee2mqtt-networkmap";
    rev = "v${version}";
    hash = "sha256-S4iUTjI+pFfa8hg1/lJSI1tl2nEIh+LO2WTYhWWLh/s=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-yo+K3vUJH6WwyNj/UuvbhhmhdqzJ3XUzX+cKUueutjE=";
  };

  configurePhase = ''
    runHook preConfigure

    cp -r $node_modules node_modules
    chmod +w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/zigbee2mqtt-networkmap.js $out/

    runHook postInstall
  '';

  dontFixup = true;

  doDist = false;

  passthru.entrypoint = "zigbee2mqtt-networkmap.js";
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    changelog = "https://github.com/azuwis/zigbee2mqtt-networkmap/releases/tag/v${version}";
    description = "Home Assistant Custom Card to show Zigbee2mqtt network map";
    homepage = "https://github.com/azuwis/zigbee2mqtt-networkmap";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
