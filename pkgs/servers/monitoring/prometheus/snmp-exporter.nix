{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-6UTvzcN0BB4uLfyZxr8CkmlMAjggYRV/EmQPRD7ZqmY=";
  };

  vendorHash = "sha256-0WGiVM4HTgcVkCxfjW1c+z1wlf/ay5BXZXuGRPS4guc=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) snmp;
  };

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
