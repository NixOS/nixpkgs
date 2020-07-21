{ stdenv, buildGoPackage, fetchFromGitHub, net-snmp, nixosTests }:

buildGoPackage rec {
  pname = "snmp_exporter";
  version = "0.18.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "1zdkb036zy2sw1drlp2m2z1yb7857d2y3yn2y3l0a1kkd4zcqkk4";
  };

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with stdenv.lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz Frostman ];
    platforms = platforms.unix;
  };
}
