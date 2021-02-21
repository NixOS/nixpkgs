{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.17.3";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-DJvXGjh1FN6SHcfVUlbfoKgBD1ThaJMvKUqvIKCyzeI=";
  };

  vendorSha256 = "sha256-UTdJT4cwRCqkn01YXB1KYc7hp1smpZFke9aAODd/2x0=";

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
