{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-/uNmY4xON9VFXEi4njAC5nD1RVWn+nUr1oQnt9w8pmQ=";
  };

  vendorHash = "sha256-WSqkuRzeSctO+modNHBGBD3HvhrSXFlmsdfB/3lS5sw=";

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
