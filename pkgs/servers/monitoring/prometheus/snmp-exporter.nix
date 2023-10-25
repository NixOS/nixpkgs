{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-HncffOX0/z8XIEXTOkt6bcnAfY7xwgNBGhUwC3FIJjo=";
  };

  vendorHash = "sha256-n0LPKmGPxLZgvzdpyuE67WOJv7MKN28m7PtQpWYdtMk=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz Frostman ];
  };
}
