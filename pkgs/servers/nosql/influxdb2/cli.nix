{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-9FUchI93xLpQwtpbr5S3GfVrApHaemwbnRPIfAWmG6Y=";
  };

in buildGoModule {
  pname = "influx-cli";
  version = version;
  src = src;

  vendorSha256 = "sha256-Boz1G8g0fjjlflxZh4V8sd/v0bE9Oy3DpqywOpKxjd0=";
  subPackages = [ "cmd/influx" ];

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
