{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-uOlkqp0/X8EiuiPWe58WADXicrBhDJTX4Jj0APQ3j5U=";
  };

in buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  vendorSha256 = "sha256-TnPvozwp7bU4BRu3gYce1jyuMClo5YiMGskXZvZqstA=";
  subPackages = [ "cmd/influx" ];

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
