{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.19.3";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "sha256-14nwSLCurI9vNgZwad3qc2/yrvpc8Og8jojTCAfJ5F0=";
  };

  vendorSha256 = "sha256-J48ezMi9+PxohDKFhBpbcu6fdojlZPXnQQw2IcyimTA=";
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
