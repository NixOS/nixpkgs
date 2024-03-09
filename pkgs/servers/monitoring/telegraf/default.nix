{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, testers
, telegraf
}:

buildGoModule rec {
  pname = "telegraf";
  version = "1.29.5";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    hash = "sha256-yVxpUKEmy7pllZQq6A0zIDekewh4BQX+/kaeLcZ2aLg=";
  };

  vendorHash = "sha256-amcI5X/xLOjItraG+twsv7sn5ei3mkZsclEd4TGiXwM=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) telegraf;
    version = testers.testVersion {
      package = telegraf;
    };
  };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 roblabla timstott zowoq ];
  };
}
