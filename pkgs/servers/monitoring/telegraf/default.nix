<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, testers
, telegraf
}:

buildGoModule rec {
  pname = "telegraf";
  version = "1.27.4";
=======
{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.26.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HcNqvl8wWMMefrRl7cXgfE22+dzebhVmo7vKf0nEIyk=";
  };

  vendorHash = "sha256-z1HNOVsSdA5bf0iZcAhbXgv/IaFpHjfoe7rqMtmscQM=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) telegraf;
    version = testers.testVersion {
      package = telegraf;
    };
  };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 roblabla timstott zowoq ];
=======
    sha256 = "sha256-Y3WDhYJ4So0vcJPvd+1l8Fpuqa84vm7A1Teh5G+pOmI=";
  };

  vendorHash = "sha256-uEqFst42z8tfTgnNF4l/8+6XakRPsT0qL0YJOQD/z60=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
