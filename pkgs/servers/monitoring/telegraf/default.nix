{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.14.2";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "009m9hysih55dn4p21vr7jfgc6l5jywyl98q3k068z5skrd8xqdb";
  };

  vendorSha256 = "05nj99hl5f5l0a2aswy19wmbm94hd1h03r227gmn419dkzc5hpah";

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