{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-6Y2zJwY5gToJlY6iLug2jNXXtNLNz98WoTKGcWgYzaA=";
  };

  vendorHash = "sha256-8soLDI/hBzSZB6Lfj1jVkIWfIkMPJmp84bu7TKg7jeo=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ oida Frostman ];
  };
}
