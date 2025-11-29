{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-eM3R4wNsBeGscaTzqdrj9ceiKFjRF3F78SWDamNMEYM=";
  };

  vendorHash = "sha256-C5iY3hBqepxLkGwPDVmnDf/ugF4h5y8scEomU9mkMEM=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Frostman
    ];
  };
}
