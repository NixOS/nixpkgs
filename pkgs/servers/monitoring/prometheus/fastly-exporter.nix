{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-GF+b0rDa9RBnLsT/ZFjSH/GIXG+Hmwew5UfXhK52AGg=";
  };

  vendorHash = "sha256-teGcQX4QbH2RnnIE46VIiYce1TzIwSX41r7FOMsxAvg=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    teams = [ lib.teams.deshaw ];
    mainProgram = "fastly-exporter";
  };
}
