{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.17.0";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "1j3wi398vcvlnf1q335hhbw6bq69qclak92sg2na05cl4snw68y0";
  };

  vendorSha256 = "0vb1gvmj7pmz4dljyk91smkn8japmv7mc3mgb0s1imvxala8qq83";

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    license = licenses.mit;
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    maintainers = with maintainers; [ mic92 roblabla timstott foxit64 ];
  };
}
