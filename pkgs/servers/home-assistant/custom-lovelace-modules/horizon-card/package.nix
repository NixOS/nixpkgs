{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarn-berry,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "horizon-card";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "rejuvenate";
    repo = "lovelace-horizon-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n8UNL5kSwLz1ncGranmbGyIC5mIKGIV2F3cEF0PSwnU=";
  };

  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/rejuvenate/lovelace-horizon-card/blob/main/package.json#L4
    ./yarn-4.14-support.patch
  ];

  nativeBuildInputs = [
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  # nix run nixpkgs#yarn-berry_4.yarn-berry-fetcher missing-hashes yarn.lock
  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-WrBUsho7GZI/Un2zvhqZ970psDeAiESiBGJikgX3E5Q=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install dist/lovelace-horizon-card.js -Dt $out

    runHook postInstall
  '';

  passthru.entrypoint = "lovelace-horizon-card.js";

  meta = {
    description = "Sun Card successor: Visualize the position of the Sun over the horizon";
    homepage = "https://github.com/rejuvenate/lovelace-horizon-card";
    changelog = "https://github.com/rejuvenate/lovelace-horizon-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
