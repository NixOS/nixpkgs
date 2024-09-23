{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
}:

mkYarnPackage rec {
  pname = "button-card";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "button-card";
    rev = "v${version}";
    hash = "sha256-Ntg1sNgAehcL2fT0rP0YHzV5q6rB5p1TyFXtbZyB3Vo=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-OFnsRR9zA9D22xBdh4XfLueGVA2ERXmGEp54x0OFDFY=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./deps/button-card/dist/button-card.js $out

    runHook postInstall
  '';

  doDist = false;

  meta = with lib; {
    description = "Lovelace button-card for home assistant";
    homepage = "https://github.com/custom-cards/button-card";
    changelog = "https://github.com/custom-cards/button-card/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
