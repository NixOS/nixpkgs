{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.50.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-FP5X+2OFEFUJWtMKbVgcCkNSV3BtQyMVsXGD6dn3mjY=";
  };

  vendorHash = "sha256-Owfxy7WkucQ6BM8yjnZg9/8CgopGTtbQTTUuxoT3RRE=";

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
    platforms = platforms.unix;
  };
}
