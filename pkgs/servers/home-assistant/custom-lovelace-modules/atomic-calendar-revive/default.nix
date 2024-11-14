{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
}:

mkYarnPackage rec {
  pname = "atomic-calendar-revive";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "totaldebug";
    repo = "atomic-calendar-revive";
    rev = "v${version}";
    hash = "sha256-TaxvxAUcewQH0IMJ0/VjW4+T6squ1tuZIFGn3PE3jhU=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    name = "${pname}-yarn-offline-cache";
    yarnLock = src + "/yarn.lock";
    hash = "sha256-d3lk3mwgaWMPFl/EDUWH/tUlAC7OfhNycOLbi1GzkfM=";
  };

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./deps/atomic-calendar-revive/dist/atomic-calendar-revive.js $out

    runHook postInstall
  '';

  doDist = false;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    changelog = "https://github.com/totaldebug/atomic-calendar-revive/releases/tag/v${src.rev}";
    description = "An advanced calendar card for Home Assistant Lovelace";
    homepage = "https://github.com/totaldebug/atomic-calendar-revive";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
