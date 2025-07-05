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
  version = "2.8.12";

  src = fetchFromGitHub {
    owner = "pkissling";
    repo = "clock-weather-card";
    tag = "v${version}";
    hash = "sha256-zggZEfbLLEUzt3ax6ag1IUbCQzjFCN6TWoMWD64mBEg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-KSuhHH06wkO9IdgoIu3cahOMmfzrjqoXqfER2N/J93A=";
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
