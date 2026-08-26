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
  pname = "button-card";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "button-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UJ9DzoT0XAWTxUXtnfOrpd0MQihBw9LY7QI0TXEbUNk=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-zbuurXlIz13zCAMKOl+/VvsVHrDscNkweZG1eiqrnUM=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/button-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "Lovelace button-card for home assistant";
    homepage = "https://github.com/custom-cards/button-card";
    changelog = "https://github.com/custom-cards/button-card/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
})
