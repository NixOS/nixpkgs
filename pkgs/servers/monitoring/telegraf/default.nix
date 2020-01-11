{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "telegraf";
  version = "1.12.1";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = version;
    sha256 = "00cd4kskdswcinv5bhwimggi0vbznq3sb2dllkhidx0bird3wdiw";
  };

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla ];
  };
}
