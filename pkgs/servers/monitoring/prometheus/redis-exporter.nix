{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-KF3tbMgcmZHn8u2wPVidH35vi/Aj7xXUvXPXUci6qrM=";
  };

  vendorHash = "sha256-zwWiUXexGI9noHSRC+h9/IT0qdNwPMDZyP3AIKtnRn0=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a redis server
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = with lib; {
    description = "Prometheus exporter for Redis metrics";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ma27 ];
  };
}
