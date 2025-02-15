{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
}:
stdenvNoCC.mkDerivation rec {
  pname = "clock-weather-card";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "pkissling";
    repo = "clock-weather-card";
    tag = "v${version}";
    hash = "sha256-ylJNI0DE+3j8EZFpUmuuBnII8nBMrJ5bhlGVh3M25eo=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-EUuPF2kS6CaJ2MUYoBocLOQyOgkhRHd34ul+efJua7Q=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/clock-weather-card.js $out/

    runHook postInstall
  '';

  meta = {
    description = "A Home Assistant Card indicating today's date/time, along with an iOS inspired weather forecast for the next days with animated icons";
    homepage = "https://github.com/pkissling/clock-weather-card";
    changelog = "https://github.com/pkissling/clock-weather-card/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
    platforms = lib.platforms.all;
  };
}
