{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.18.1";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-iFigbnqUXWQrhDovwQYZsr8llkB9553c5LgcKJ78yZ4=";
  };

  vendorSha256 = "sha256-m53S/L71nyioCBbIDDAWEnqStBdqTFGq16y5ozsXq1c=";

  preBuild = ''
    buildFlagsArray+=("-ldflags=-w -s -X main.version=${version}")
  '';

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla timstott foxit64 ];
  };
}
