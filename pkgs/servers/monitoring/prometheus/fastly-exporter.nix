{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-SpYdcLPknI7ecZ2ef3kJ2nBkQ39vzjk1fNTdDaFZwO0=";
  };

  vendorHash = "sha256-k/n9muWFtTBv8PxMdevFBeTtAOIiCDrK3GoCGeMtBn4=";

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
