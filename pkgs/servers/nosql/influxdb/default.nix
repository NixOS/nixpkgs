{ lib, buildGoPackage, fetchFromGitHub, }:

buildGoPackage rec {
  pname = "influxdb";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gwivazjvxw6fflf2637qn0crq564fjzhncsl3agph5ciqyv48gx";
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
