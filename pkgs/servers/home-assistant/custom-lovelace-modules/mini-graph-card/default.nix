{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    rev = "refs/tags/v${version}";
    hash = "sha256-AC4VawRtWTeHbFqDJ6oQchvUu08b4F3ManiPPXpyGPc=";
  };

  npmDepsHash = "sha256-0ErOTkcCnMqMTsTkVL320SxZaET/izFj9GiNWC2tQtQ=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/mini-graph-card-bundle.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "mini-graph-card-bundle.js";

  meta = with lib; {
    changelog = "https://github.com/kalkih/mini-graph-card/releases/tag/v${version}";
    description = "Minimalistic graph card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-graph-card";
    maintainers = with maintainers; [ hexa ];
    license = licenses.mit;
  };
}

