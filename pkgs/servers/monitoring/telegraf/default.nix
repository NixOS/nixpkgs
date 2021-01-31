{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.17.2";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-R0RYiVVS1ce2xabPBTEmOxBNlknP4iXkbVy412whrFw=";
  };

  vendorSha256 = "sha256-3cELah9i2rY563QQOYt7ke0HEUR1By74vTgl+UbOHwc=";

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla timstott foxit64 ];
  };
}
