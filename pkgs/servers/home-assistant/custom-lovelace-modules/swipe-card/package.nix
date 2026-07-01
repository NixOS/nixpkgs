{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnBuildHook,
  yarnConfigHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swipe-card";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "bramkragten";
    repo = "swipe-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UC4Oz+2pRdZsNSwjb21jNrTBa+txtXf0CAoJKi2SLXo=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-rtc5vAPWmPYiORf4LkPpa4IB8Oi0VQpS+1kWhXiUMo8=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./dist/swipe-card.js $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Card that allows you to swipe throught multiple cards for Home Assistant Lovelace";
    homepage = "https://github.com/bramkragten/swipe-card";
    changelog = "https://github.com/bramkragten/swipe-card/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Gambled23 ];
    platforms = lib.platforms.all;
  };
})
