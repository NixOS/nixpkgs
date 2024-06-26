{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    rev = "refs/tags/v${version}";
    hash = "sha256-cDgfAfS4U3ihN808KPcG+jEQR+S2Q1M5SPqOkkYwYkI=";
  };

  npmDepsHash = "sha256-v+DqUAMNtDruR8E0sy7uAu3jndZUHkOw2xKtpY163R8=";

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
