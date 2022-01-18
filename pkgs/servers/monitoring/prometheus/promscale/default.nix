{ lib
, buildGoModule
, fetchFromGitHub
, promscale
, testVersion
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-OMDl8RGFOMW+KNX2tNHusJY/6gLZxuWCI3c0E/oqrfE=";
  };

  patches = [
    ./0001-remove-jaeger-test-dep.patch
  ];

  vendorSha256 = "sha256-IwHngKiQ+TangEj5PcdiGoLxQJrt/Y3EtbSYZYmfUOE=";

  ldflags = [ "-s" "-w" "-X github.com/timescale/promscale/pkg/version.Version=${version}" "-X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

  doCheck = false; # Requires access to a docker daemon

  passthru.tests.version = testVersion {
    package = promscale;
    command = "promscale -version";
  };

  meta = with lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
