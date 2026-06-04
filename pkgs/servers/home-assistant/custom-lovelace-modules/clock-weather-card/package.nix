{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarn-berry,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "clock-weather-card";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "pkissling";
    repo = "clock-weather-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CeOrJFdvl9O6TF9E2W34mR6VmLnTzhXGmrBmbtsBLxA=";
  };

  patches = [
    # Remove after upstream updates to Yarn 4.14
    ./yarn-4.14-support.patch
  ];

  nativeBuildInputs = [
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches missingHashes;
    hash = "sha256-d0xLK8CwunIsa6qdp/4iQIQhO8GJT20pztbJDNcoYrY=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install dist/clock-weather-card.js -Dt $out

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant Card indicating today's date/time, along with an iOS inspired weather forecast for the next days with animated icons";
    homepage = "https://github.com/pkissling/clock-weather-card";
    changelog = "https://github.com/pkissling/clock-weather-card/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
    platforms = lib.platforms.all;
  };
})
