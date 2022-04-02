{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.22.0";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-Y7vR6kmh1rObDyyHA2NFvBkilBz+Bx8BHqlAoVY/gGo=";
  };

  vendorSha256 = "sha256-oSN6nHOtXA2cSZEmToRvALkSxAyel9BU7bh1groEnsw=";
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
