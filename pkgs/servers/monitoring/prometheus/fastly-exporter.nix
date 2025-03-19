{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "9.1.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-1xgTAMsUw+eYeHD6NEo2Zw3fL1Hdm6fxQWfgp/VQaXc=";
  };

  vendorHash = "sha256-NbMvDaD4E6mYypPRSqNBjToCffldJzh33wuq83hWM9A=";

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
