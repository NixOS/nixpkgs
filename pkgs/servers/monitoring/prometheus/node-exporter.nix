{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "node_exporter-${version}";
  version = "0.14.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "0rm43jjqv7crfahl973swi4warqmqnmv740cg800yvzvnlp37kl4";
  };

  # FIXME: megacli test fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
