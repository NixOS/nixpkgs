{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
    sha256 = "sha256-aClwJ+J83iuZbfNP+Y1vKEjBULD5wh/R3TMceCccacc=";
  };

  vendorHash = "sha256-0EXRpehdpOYpq6H9udmNnQ24EucvAcPUKOlFSAAewbE=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
