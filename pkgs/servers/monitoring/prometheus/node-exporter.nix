{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "node_exporter-${version}";
  version = "0.15.2";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "1vxbkps80ba8c0ndawijg07am5gyc8y49h8fd0ky5h05zmkp25qv";
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
