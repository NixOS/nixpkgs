{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
}:

mkYarnPackage rec {
  pname = "horizon-card";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rejuvenate";
    repo = "lovelace-horizon-card";
    rev = "v${version}";
    hash = "sha256-GJzclfyk/HsT5NVRh6T1mUpEAVKWjovH71ZY2JoBUig=";
  };

  # packageJSON = src + "/package.json";

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-111sRR9zA9D22xBdh4XfLueGVA2ERXmGEp54x0OFDFY=";
  };

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/horizon-card.js $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sun Card successor: Visualize the position of the Sun over the horizon";
    homepage = "https://github.com/rejuvenate/lovelace-horizon-card";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
