{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "node_exporter";
  version = "1.1.2";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "1kz52zhsm0xx63vczzplj15hli4i22qfxl08grb7m50bqk651j1n";
  };

  vendorSha256 = "05lr2ln87902bwamw4l3rrk2j9sdgv1pcvxyvzbga64rymi9dmjb";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  excludedPackages = [ "docs/node-mixin" ];

  buildFlagsArray = let
    goPackagePath = "github.com/prometheus/node_exporter";
  in ''
    -ldflags=
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Version=${version}
        -X ${goPackagePath}/vendor/github.com/prometheus/common/version.Revision=${rev}
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  meta = with lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = "https://github.com/prometheus/node_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
    platforms = platforms.unix;
  };
}
