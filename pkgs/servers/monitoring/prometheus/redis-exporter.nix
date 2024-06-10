{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.61.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-ZfjOsPUr72Ex+5SR2oVMybbR20hwqlto3teTJcdtALA=";
  };

  vendorHash = "sha256-nrEglhb22LANgm6hiZToPVPfGpkpxpJ7TQlLW0Z7+/4=";

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
