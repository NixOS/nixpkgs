{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mushroom";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "v${version}";
    hash = "sha256-H3dTOFezhkzCScgzOk7BrQ3wd2mZ0o5zD+QG0Jk36YY=";
  };

  npmDepsHash = "sha256-tufEkxFr8ReYXJb/7u//m2CXpoIhLQIWGxObfl44B2o=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/mushroom.js $out

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/piitaya/lovelace-mushroom/releases/tag/v${version}";
    description = "Mushroom Cards - Build a beautiful dashboard easily";
    homepage = "https://github.com/piitaya/lovelace-mushroom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
