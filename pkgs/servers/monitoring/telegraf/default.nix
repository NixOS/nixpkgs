{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "telegraf";
  version = "1.13.2";

  goPackagePath = "github.com/influxdata/telegraf";

  excludedPackages = "test";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = version;
    sha256 = "1vcnac1gj7ri1hdlkz5i6zpxiwljpfn1iag1zb3fymlw6c91b11p";
  };

  buildFlagsArray = [ ''-ldflags=
    -w -s -X main.version=${version}
  '' ];

  passthru.tests = { inherit (nixosTests) telegraf; };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics.";
    license = licenses.mit;
    homepage = https://www.influxdata.com/time-series-platform/telegraf/;
    maintainers = with maintainers; [ mic92 roblabla foxit64 ];
  };
}
