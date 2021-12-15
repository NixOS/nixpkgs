{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "2.2.1";
  shorthash = "31ac783"; # git rev-parse --short HEAD with the release checked out

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

  vendorSha256 = "sha256-G9S7gAuDNwxADekOr9AaXDkPDSXVlc9Fi4gdrKdy0rI=";
  subPackages = [ "cmd/influx" ];

  /*preBuild = ''
    mkdir -p static/data
    tar -xzf ${ui} -C static/data

    grep -RI -e 'go:generate.*go-bindata' | cut -f1 -d: | while read -r filename; do
      sed -i -e 's/go:generate.*go-bindata/go:generate go-bindata/' $filename
      pushd $(dirname $filename)
      go generate
      popd
    done
  '';

  tags = [ "assets" ];*/

  ldflags = [ "-X main.commit=${shorthash}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar ];
  };
}
