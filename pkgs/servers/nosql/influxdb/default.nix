{ lib, buildGoPackage, fetchFromGitHub, }:

buildGoPackage rec {
  pname = "influxdb";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "07abzhmsgj7krmhf7jis50a4fc4w29h48nyzgvrll5lz3cax979q";
  };

  buildFlagsArray = [ ''-ldflags=
    -X main.version=${version}
  '' ];

  goPackagePath = "github.com/influxdata/influxdb";

  excludedPackages = "test";

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdata.com/;
    maintainers = with maintainers; [ offline zimbatm ];
  };
}
