{ lib
, fetchFromGitHub
, fetchYarnDeps
, mkYarnPackage
}:

mkYarnPackage rec {
  pname = "zigbee2mqtt-networkmap";
  version = "unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "zigbee2mqtt-networkmap";
    rev = "d5f1002118ba5881c6bdc27cb0f67642575c414f";
    hash = "sha256-ITqzMjom2XN7+ICDH0Z5YJWY5GNUXzaqSuEzXekhw9I=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-uPhD6UQ1KI7y6bqqQF7InT9eKU9VWGf2D60Lo5Mwcf8=";
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

  meta = with lib; {
    description = "Home Assistant Custom Card to show Zigbee2mqtt network map";
    homepage = "https://github.com/azuwis/zigbee2mqtt-networkmap";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
