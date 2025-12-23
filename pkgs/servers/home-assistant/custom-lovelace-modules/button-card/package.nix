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
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "button-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ntg1sNgAehcL2fT0rP0YHzV5q6rB5p1TyFXtbZyB3Vo=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-OFnsRR9zA9D22xBdh4XfLueGVA2ERXmGEp54x0OFDFY=";
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
