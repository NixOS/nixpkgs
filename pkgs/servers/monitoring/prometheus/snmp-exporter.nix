{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-ko2PApbz8kL0n6IEsRKLwMq9WmAdvfwI6o7ZH/BTd6c=";
  };

  vendorSha256 = "sha256-nbJXiZ+vHN/EnvAPTJUKotCE+nwdrXtWHhGfugm+CQQ=";

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
