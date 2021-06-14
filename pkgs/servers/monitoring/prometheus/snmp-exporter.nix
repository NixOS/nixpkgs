{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "0qwbnx3l25460qbah4ik9mlcyrm31rwm51451gh0jprii80cf16x";
  };

  vendorSha256 = "1rivil3hwk269ikrwc4i22k2y5c9zs5ac058y7llz8ivrrjr2w4h";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz Frostman ];
    platforms = platforms.unix;
  };
}
