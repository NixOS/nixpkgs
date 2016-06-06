{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "node_exporter-${version}";
  version = "0.11.0";
  rev = version;
  
  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "149fs9yxnbiyd4ww7bxsv730mcskblpzb3cs4v12jnq2v84a4kk4";
  };

  goDeps = ./node-exporter_deps.json;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
