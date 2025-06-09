{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    tag = "v${version}";
    hash = "sha256-flZfOVY0/xZOL1ZktRGQhRyGAZronLAjpM0zFpc+X1U=";
  };

  npmDepsHash = "sha256-xzhyYYZLl8pyfK3+MRn35Ffdw/c78v8PjwLlAuQO92g=";

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
