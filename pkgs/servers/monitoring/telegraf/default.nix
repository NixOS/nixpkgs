{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.20.3";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-KziXTuj1J3pXJIACiF09En3rRt1BYixj/jAadyaz4ns=";
  };

  vendorSha256 = "sha256-4L65JT+5GRS7KszuwKdveOlJIrOptPomDuyQ/r434cc=";
  proxyVendor = true;

  ldflags = [
    "-w" "-s" "-X main.version=${version}"
  ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla timstott ];
  };
}
