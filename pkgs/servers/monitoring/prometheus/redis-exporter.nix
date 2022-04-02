{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-S60/SwbMp6INf98MGc26zMZH8q7gBynyaT/ivN7o0rA=";
  };

  vendorSha256 = "sha256-u9FfKOD6kiCFTjwQ7LHE9WC4j2vPm0ZCluL8pC4aQIc=";

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
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
    platforms = platforms.unix;
  };
}
