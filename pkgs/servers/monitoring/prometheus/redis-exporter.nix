{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.65.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-koUvcWd5AWhkxIfMJc0YOHaurO4evf83xn+bBCbyiPY=";
  };

  vendorHash = "sha256-gTxNuqaGpigtRwYIU69woebze0QoLZE+ArROUsQAUwA=";

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
    mainProgram = "redis_exporter";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ma27 ];
  };
}
