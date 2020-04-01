{ stdenv, buildGoPackage, fetchFromGitHub, net-snmp }:

buildGoPackage rec {
  pname = "snmp_exporter";
  version = "0.17.0";

  goPackagePath = "github.com/prometheus/snmp_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "0s2vgcpxannyl1zllc3ixww02832s53zijws64lhd8mxrylqvpcp";
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
