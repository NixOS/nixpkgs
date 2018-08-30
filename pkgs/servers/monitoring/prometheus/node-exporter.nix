{ stdenv, buildGo19Package, fetchFromGitHub }:

# Go 1.10 causes segfaults:
# https://github.com/prometheus/node_exporter/issues/870
buildGo19Package rec {
  name = "node_exporter-${version}";
  version = "0.16.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "0rm6ahccgr1djpwvsa3p1kfal3mpy4a6g5w974pra84gk3krli5a";
  };

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
