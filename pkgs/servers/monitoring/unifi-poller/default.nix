{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "unifi-poller";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "unifi-poller";
    repo = "unifi-poller";
    rev = "v${version}";
    hash = "sha256-jPatTo+5nQ73AETXI88x/bma0wlY333DNvuyaYQTgz0=";
  };

  vendorHash = "sha256-Y4FcBLdVB3AjJOpP2CuoNVAIxaqlZxHI0yKzp7Wqpwc=";

  ldflags = [
    "-w" "-s"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Version=${version}-0"
  ];

  meta = with lib; {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unifi-poller/unifi-poller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
