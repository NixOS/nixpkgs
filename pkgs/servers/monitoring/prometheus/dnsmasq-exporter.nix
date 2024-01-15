{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dnsmasq_exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    rev = "v${version}";
    hash = "sha256-8r5q5imI+MxnU7+TFqdIc+JRX0zZY4pmUoAGlFqs8cQ=";
  };

  vendorHash = "sha256-dEM0mn3JJl0M6ImWmkuvwBSfGWkhpVvZE7GtC1BQF7c=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dnsmasq; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A dnsmasq exporter for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ];
  };
}
