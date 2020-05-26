{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "node_exporter";
  version = "1.0.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "12v7vaknvll3g1n7730miwxiwz8nbjq8y18lzljq9d9s8apcy32f";
  };

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Version=${version}
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Revision=${rev}
  '';

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = "https://github.com/prometheus/node_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
    platforms = platforms.unix;
  };
}
