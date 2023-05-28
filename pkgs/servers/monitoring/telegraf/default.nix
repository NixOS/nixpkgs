{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.26.3";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-B1jYtJFj9hQT2ub9KaeoiWJZN9CHyZzA7juk0JZ0ZAo=";
  };

  vendorHash = "sha256-dwUVmUzQn66Pz4vY9JIHVImiM4FwbAPZctSach/jH4c=";
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
