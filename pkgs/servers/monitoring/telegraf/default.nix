{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.14.0";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "062j4sm7im4iv5i9afr771724srvwwcqbhkyznlzncaz06mk1sn7";
  };

  modSha256 = "1q7il1x1pfyz15z23cs0kk7zyacn6b3y28b1q52bqi30l1x8bdbp";

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla foxit64 ];
  };
}
