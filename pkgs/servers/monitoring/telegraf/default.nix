{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, testers
, telegraf
}:

buildGoModule rec {
  pname = "telegraf";
  version = "1.30.3";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    hash = "sha256-B3Eeh3eOYg58NnMpV6f04HFzOtOn/enBqzCJRst6u2U=";
  };

  vendorHash = "sha256-Cudnc5ZyCQUqgao58ww69gfF6tPW6/oGP9zXbuPSTAE=";
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
    mainProgram = "telegraf";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 roblabla timstott zowoq ];
  };
}
