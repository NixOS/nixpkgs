{ stdenv, lib, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "snmp_exporter-${version}";
  version = "0.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "snmp_exporter";
    sha256 = "1faa1gla5nqkhf1kq60v22bcph41qix3dn9db0w0fh2pkxpdxvrp";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = https://github.com/prometheus/snmp_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.unix;
  };
}
