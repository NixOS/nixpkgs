{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.7.11";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-/tGmMeHrurKTaRQLHusOkjISuxrrT/JjUCimEL7zoIk=";
  };

  vendorHash = "sha256-ZwJCqL8vU38k8pfNmKGIhJSgMwxQuzBBfl6IduQrQEw=";

  ldflags = [
    "-w" "-s"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Version=${version}-0"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) unpoller; };

  meta = with lib; {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unpoller/unpoller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Frostman ];
  };
}
