{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "telegraf";
  version = "1.15.2";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    sha256 = "045wjpq29dr0s48ns3a4p8pw1j0ssfcw6m91iim4pkrppj7bm2di";
  };

  patches = [
    # https://github.com/influxdata/telegraf/pull/7988
    # fix broken cgo vendoring
    (fetchpatch {
      url = "https://github.com/influxdata/telegraf/commit/63e1f41d8ff246d191d008ff7f69d69cc34b4fae.patch";
      sha256 = "0ikifc4414bid3g6hhxz18cw71z63s5g805klx98vrndjlpbqkzw";
    })
  ];

  vendorSha256 = "0f95xigpkindd7dmci8kqpqq5dlirimbqh8ai73142asbrd5h4yr";

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
