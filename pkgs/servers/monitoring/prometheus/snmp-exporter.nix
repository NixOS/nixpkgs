{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-GXO8coOyvoLJdh7UodEit9s0KDL3Aji6SNxbjPccW6k=";
  };

  vendorHash = "sha256-41P1ilRJKekreKX1PwT2SGO4YW0wD3MOpEy4FdyRZD4=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      oida
      Frostman
    ];
  };
}
