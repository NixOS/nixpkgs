{ stdenv, buildGoPackage, fetchFromGitHub, net-snmp }:

buildGoPackage rec {
  pname = "snmp_exporter";
  version = "0.19.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "1ppi5lmc2lryawpw1b3kpg3qxr7v62zbiwg2v1d8sq1y5b2xdza6";
  };

  buildInputs = [ net-snmp ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = https://github.com/prometheus/snmp_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz ];
    platforms = platforms.unix;
  };
}
