{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-E7BmszlFTok5DsIVqZiYd/HC1P2euxiABb4BRVh//eQ=";
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

  vendorHash = "sha256-3BoA8DOLRtJXbGXrTVY9qaD+JEz5EjsXp0DDQCbUuzY=";

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
