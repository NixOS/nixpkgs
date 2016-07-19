{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "node_exporter-${version}";
  version = "0.12.0";
  rev = version;

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "0ih8w9ji0fw1smsi45jgvrpqfzm3f5bvk9q3nwrl0my5xkksnr8g";
  };

  # FIXME: megacli test fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
