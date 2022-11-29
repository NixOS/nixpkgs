{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.24.3";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-3KQJRapgl36+QwWHjh+nri3FcFtXhre7l3XN8Oj9t+0=";
  };

  vendorSha256 = "sha256-0PQYnJKDR/CtZviy0FXvVja7fvcvY+BH8zQXiGdKqRg=";
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
