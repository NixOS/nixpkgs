{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  version = "0.5.0";
in
buildGoModule {
  pname = "unbound_exporter";
  inherit version;

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "unbound_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-xVc6xES3YdKIaP6rwAzI0/RLoer7bcq7VAmfjYii8VI=";
  };

  vendorHash = "sha256-6ZiBXQRsmlUU7h9Dvlb5WHnYAjrrhbw0rypP5ChoKPs=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = {
    changelog = "https://github.com/letsencrypt/unbound_exporter/releases/tag/v${version}";
    description = "Prometheus exporter for Unbound DNS resolver";
    mainProgram = "unbound_exporter";
    homepage = "https://github.com/letsencrypt/unbound_exporter/tree/main";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
