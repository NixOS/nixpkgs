{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-tlaKjJmk+ZxeQ5KQ9Ai4XGKYqiLWwAlzkRuFjKLSaog=";
  };

  vendorHash = "sha256-e1+T4+TgSB5pR4YiwtOuNztAXxWfCokFczbZcUNF7iI=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
    mainProgram = "fastly-exporter";
  };
}
