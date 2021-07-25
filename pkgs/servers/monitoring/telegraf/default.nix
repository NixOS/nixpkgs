{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.19.1";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-8shyNKwSg3pUxfQsIHBNnIaks/86vHuHN/SroDE3QFU=";
  };

  vendorSha256 = "sha256-GMNyeWa2dz+q4RYS+DDkpj9sx1PlPvSuWYcHSM2umRE=";
  proxyVendor = true;

  preBuild = ''
    buildFlagsArray+=("-ldflags=-w -s -X main.version=${version}")
  '';

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla timstott ];
  };
}
