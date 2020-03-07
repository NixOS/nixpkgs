{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "telegraf";
  version = "1.13.4";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = version;
    sha256 = "031hq9dg87cqj4am7qkbgfan2s6bqc2hf48h0gnrv78hbz8icxa1";
  };

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla foxit64 ];
  };
}
