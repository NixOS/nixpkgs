{ stdenv, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "node_exporter";
  version = "1.0.1";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "1r0xx81r9v019fl0iv078yl21ndhb356y7s7zx171zi02k7a4p2l";
  };

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Version=${version}
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Revision=${rev}
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = "https://github.com/prometheus/node_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
    platforms = platforms.unix;
  };
}
