{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "unifi-poller";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "unifi-poller";
    repo = "unifi-poller";
    rev = "v${version}";
    sha256 = "sha256-C7QjMzmy2CMCk2oqRiThUQBKgltT0PzZArvZ+gOmJ2I=";
  };

  vendorSha256 = "sha256-LOBkdyfsw7ua6TsLglO5jdR9NWo5Df8rnQ8MH+eIz4g=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
    platforms = platforms.unix;
  };
}
