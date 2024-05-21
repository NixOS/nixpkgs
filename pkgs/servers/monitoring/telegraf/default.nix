{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, stdenv
, testers
, telegraf
}:

buildGoModule rec {
  pname = "telegraf";
  version = "1.30.2";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    hash = "sha256-y9FfCCOUl0IWwcol1aDG+1m7270wWc3akhZzaK/KItY=";
  };

  vendorHash = "sha256-7X2k/fpr9zQNXfyd+18VpRTcmYvPBvQzPNolNfmIZG8=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = telegraf;
    };
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) telegraf;
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
