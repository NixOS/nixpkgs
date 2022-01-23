{ lib, buildGo117Module, fetchFromGitHub, nixosTests }:

buildGo117Module rec {
  pname = "telegraf";
  version = "1.21.2";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-LLVEFpi9qeIg9w3MyFa0FIPIEthiy2s8sl87W+T0pqQ=";
  };

  vendorSha256 = "sha256-w9fJjmNvHfsV/o/0+NTTjX4VmzUg8laNHvYHwv0MdOI=";
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
