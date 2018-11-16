{ stdenv, buildGoPackage, fetchFromGitHub, net_snmp }:

buildGoPackage rec {
  name = "snmp_exporter-${version}";
  version = "0.13.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "071v9qqhp2hcbgml94dm1l212qi18by88r9755npq9ycrsmawkll";
  };

  buildInputs = [ net_snmp ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = https://github.com/prometheus/snmp_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz ];
    platforms = platforms.unix;
  };
}
