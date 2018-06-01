{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, net_snmp }:

buildGoPackage rec {
  name = "snmp_exporter-${version}";
  version = "0.11.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "027p96jzhq9l7m3s5qxxg3rqp14pai7q66d3ppin19lg7al11c9x";
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
