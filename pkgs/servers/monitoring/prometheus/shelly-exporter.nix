{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule {
  pname = "shelly_exporter";
  version = "0-unstable-2025-03-19";

  src = fetchFromGitHub {
    owner = "aexel90";
    repo = "shelly_exporter";
    rev = "2e82fb01ec9337f6e2c68267e6d43c0f1677c481";
    hash = "sha256-FYz0hmZiVWL6/bBccOBzFVpjN8HqbG+7+uODC2LwxZk=";
  };

  vendorHash = "sha256-BCrge2xLT4b4wpYA+zcsH64a/nfV8+HeZF7L49p2gEw=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) shelly; };

  meta = {
    description = "Shelly humidity sensor exporter for prometheus";
    mainProgram = "shelly_exporter";
    homepage = "https://github.com/aexel90/shelly_exporter";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
