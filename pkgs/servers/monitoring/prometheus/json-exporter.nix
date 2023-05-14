{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-33cu2DG6kgzCVQPaN9L8f/Iq76RqDPa+kE7qMt8czhI=";
  };

  vendorSha256 = "sha256-aMpJaxyBBfpsRJTxAO05926tQSt8qQoDDzLFbX4qwWc=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "json_exporter";
  };
}
