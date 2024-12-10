{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  prometheus-pushgateway,
}:

buildGoModule rec {
  pname = "pushgateway";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${version}";
    sha256 = "sha256-WZ7Gi7jiHoH6ZL0TdB7Z3C9sAzxL/iJtOAm/MsZVRI8=";
  };

  vendorHash = "sha256-W2gGp36f1OZonXVkoBvWOaeGnnF5Xi5Kv8JE+iDm+fg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${version}"
    "-X github.com/prometheus/common/version.Branch=${version}"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests.version = testers.testVersion {
    package = prometheus-pushgateway;
  };

  meta = with lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    mainProgram = "pushgateway";
    homepage = "https://github.com/prometheus/pushgateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
