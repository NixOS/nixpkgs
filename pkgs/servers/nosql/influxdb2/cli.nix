{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-l27BAHQtMA4kE7VEZLdOPFnSXtyWUOrcUFitaWqwvTw=";
  };

in buildGoModule {
  pname = "influx-cli";
  version = version;
  src = src;

  vendorSha256 = "sha256-GnVLr9mWehgw8vs4RiOrFHVlPpPT/LP6XvCq94aJxJQ=";
  subPackages = [ "cmd/influx" ];

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
