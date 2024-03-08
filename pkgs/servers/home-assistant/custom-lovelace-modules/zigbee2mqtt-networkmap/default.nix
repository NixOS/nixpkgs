{ lib
, fetchFromGitHub
, fetchYarnDeps
, mkYarnPackage
}:

mkYarnPackage rec {
  pname = "zigbee2mqtt-networkmap";
  version = "unstable-2023-12-16";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = "zigbee2mqtt-networkmap";
    rev = "7851357d78ebc0d1cc3cb5c661267a1e8b4c09e3";
    hash = "sha256-x7RVy0stWT6+8f0/0VORVBgGpBbsbyJBC38xIxXhzos=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-s+vnyUeJKkkA5G0AmsfIG0Zh4bYdDc2B5MSNvdwhjgs=";
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
