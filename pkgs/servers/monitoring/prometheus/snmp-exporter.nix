{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, net_snmp }:

buildGoPackage rec {
  name = "snmp_exporter-${version}";
  version = "0.9.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "081ah4zyy53plhm6znwrx55phm2ysxzyx7d4hm8zzrv5r967rgl1";
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
