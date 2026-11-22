{
  lib,
  applyPatches,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  yarn-berry_4,
}:
let
  yarn-berry = yarn-berry_4;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "clock-weather-card";
  version = "3.1.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "pkissling";
      repo = "clock-weather-card";
      tag = "v${finalAttrs.version}";
      hash = "sha256-UbYPhGsTqrOKP2DmuQccyH33C59zFhh4C5calXUKy30=";
    };
    patches = [ ./fix-lock.diff ];
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) missingHashes;
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-d94N1mkXge7MuskFPcQb6ObcqZ/6KlSK2e8EgMBAHIE=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/clock-weather-card.js $out/

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
