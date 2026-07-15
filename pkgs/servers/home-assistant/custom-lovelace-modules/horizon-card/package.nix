{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarn-berry,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "horizon-card";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "rejuvenate";
    repo = "lovelace-horizon-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ja4r8x9sNH6W7LoH//zfXDlQb9W7KYFz4Y9UBoqt19s=";
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

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-Ztb69kAGYteVevzzFOx+62LI2i4iQakI4Fwqb6G2vuM=";
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
