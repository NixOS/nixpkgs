{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
}:

mkYarnPackage rec {
  pname = "zigbee2mqtt-networkmap";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "zigbee2mqtt-networkmap";
    rev = "v${version}";
    hash = "sha256-K4DyrurC4AzzJCcB4CS9UlQbUQSWpR7PevA2JFFMRZM=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-h/5TWaIg8AfY6I/JBRmUF6yCCbxCMs9nRECWEaaK2to=";
  };

  configurePhase = ''
    cp -r $node_modules node_modules
    chmod +w node_modules
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
