{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    rev = "refs/tags/v${version}";
    hash = "sha256-o87c1tqZAQDlzxsxVdPZj1ei37nx7dVIZDzoQIUkmPk=";
  };

  npmDepsHash = "sha256-4GgFlSpqGxY7TCgyovqMSoLUin46bKN8tUQTdjv1eog=";

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

