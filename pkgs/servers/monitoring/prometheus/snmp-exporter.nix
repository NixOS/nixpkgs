{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, net_snmp }:

buildGoPackage rec {
  name = "snmp_exporter-${version}";
  version = "0.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "snmp_exporter";
    sha256 = "1cklsi3cpalmnp0qjkgb7xbgbkr014hk2z54gfynzvzqjmsbxk6a";
  };

  buildInputs = [ net_snmp ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = https://github.com/prometheus/snmp_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.unix;
  };
}
