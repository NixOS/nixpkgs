{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-CRSfbUzyWzBmaks69Iax8IBxsWt3k48A+bfx7bLw6h4=";
  };

in buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  vendorHash = "sha256-UyAxato4NDejyomQpp15URxxYGtqmQPFdtzSuiQMJW8=";
  subPackages = [ "cmd/influx" ];

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
