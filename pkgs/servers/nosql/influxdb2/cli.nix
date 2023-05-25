{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-hRv7f2NeURsgLQ1zNgAhZvTjS0ei4+5lqokIu0iN+aI=";
  };

in buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  vendorHash = "sha256-QNhL5RPkNLTXoQ0NqcZuKec3ZBc3CDTc/XTWvjy55wk=";
  subPackages = [ "cmd/influx" ];

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
