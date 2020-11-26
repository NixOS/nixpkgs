{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.16.2";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-XdlXUwGn2isGn7SqCGaAjntposBEd6WbbdfN6dEycDI=";
  };

  vendorSha256 = "02fqx817w6f9grfc69ri06a6qygbr5chan6w9waq2y0mxvmypz28";

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla foxit64 ];
  };
}
