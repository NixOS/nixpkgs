{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.14.0-dev.3";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    tag = "v${version}";
    hash = "sha256-1ZSnFkVJ7m6c4rLBJG+hNpfRWo5Jr9SP6GuQOBAoVc8=";
  };

  npmDepsHash = "sha256-xzhyYYZLl8pyfK3+MRn35Ffdw/c78v8PjwLlAuQO92g=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/mini-graph-card-bundle.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "mini-graph-card-bundle.js";

  meta = {
    changelog = "https://github.com/kalkih/mini-graph-card/releases/tag/v${version}";
    description = "Minimalistic graph card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-graph-card";
    maintainers = with lib.maintainers; [ hexa ];
    license = lib.licenses.mit;
  };
}
