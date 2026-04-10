{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarn-berry,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "horizon-card";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rejuvenate";
    repo = "lovelace-horizon-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z2cJ6BIhNnzUo9nIFxVyrPBVWSKf35fyLXK72pE8TJw=";
  };

  nativeBuildInputs = [
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-LYPHBnDRcGeXo2btx1A4/e7fr7MYg/2G5GkuG/xDG+I=";
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

  meta = {
    description = "Sun Card successor: Visualize the position of the Sun over the horizon";
    homepage = "https://github.com/rejuvenate/lovelace-horizon-card";
    changelog = "https://github.com/rejuvenate/lovelace-horizon-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
