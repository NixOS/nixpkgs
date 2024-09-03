{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mushroom";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "v${version}";
    hash = "sha256-3zTavmuLrL/JPQE3axhGONxMhOMq0L0QvSj2pCKukmI=";
  };

  npmDepsHash = "sha256-mzFgk5cGjFBnrVHbB6QQzf1QRAeLMl/6WS3I8jbheu8=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/mushroom.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/piitaya/lovelace-mushroom/releases/tag/v${version}";
    description = "Mushroom Cards - Build a beautiful dashboard easily";
    homepage = "https://github.com/piitaya/lovelace-mushroom";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
