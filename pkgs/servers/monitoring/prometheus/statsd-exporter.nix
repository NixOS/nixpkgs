{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-hKwbC56Z6tMolLnYB5G7iSLZoM+cWCh5lPzWiFkOd6E=";
  };

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  vendorHash = "sha256-UcdRcHZUJ3XHZNqYXSboaor5WRVPYfilEvRWZjA1YNc=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    mainProgram = "statsd_exporter";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      ivan
    ];
  };
}
