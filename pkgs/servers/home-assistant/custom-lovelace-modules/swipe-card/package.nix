{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "swipe-card";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "bramkragten";
    repo = "swipe-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UC4Oz+2pRdZsNSwjb21jNrTBa+txtXf0CAoJKi2SLXo=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-rtc5vAPWmPYiORf4LkPpa4IB8Oi0VQpS+1kWhXiUMo8=";
  };

  # drop the prebuilt bundle checked into the repo, so the build regenerates it
  postPatch = ''
    rm dist/swipe-card.js
  '';

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  # `build` also runs eslint
  yarnBuildScript = "rollup";

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/swipe-card.js $out/swipe-card.js

    runHook postInstall
  '';

  meta = {
    description = "Card that allows you to swipe through multiple cards for Home Assistant Lovelace";
    homepage = "https://github.com/bramkragten/swipe-card";
    changelog = "https://github.com/bramkragten/swipe-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
