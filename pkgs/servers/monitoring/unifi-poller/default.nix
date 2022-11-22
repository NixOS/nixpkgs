{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "unifi-poller";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "unifi-poller";
    repo = "unifi-poller";
    rev = "v${version}";
    hash = "sha256-eC+jEtSLWhiL3V+GKfRN5MVF18/2tnA1kI096j3XQB0=";
  };

  vendorHash = "sha256-WVYQ3cZOO+EyJRTFcMjziDHwqqinm1IvxvSLuHTaqT8=";

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
