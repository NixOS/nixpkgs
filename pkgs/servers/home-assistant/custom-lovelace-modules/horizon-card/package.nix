{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarn-berry,
  substitute,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "horizon-card";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "rejuvenate";
    repo = "lovelace-horizon-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p4GI4R5P1LjiXwzF1Hlk6Kk57i+YUcEEsm8bN+qIYdE=";

    # Remove after upstream updates to Yarn 4.15
    # https://github.com/rejuvenate/lovelace-horizon-card/blob/main/package.json#L4
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry.lockfileVersion
          ];
        })
      }
    '';
  };

  nativeBuildInputs = [
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  # nix run nixpkgs#yarn-berry_4.yarn-berry-fetcher missing-hashes yarn.lock
  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-iHMIcnCQEbDkAugB9FO4G++eDq3/ABfp0E7Q6893fVY=";
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
