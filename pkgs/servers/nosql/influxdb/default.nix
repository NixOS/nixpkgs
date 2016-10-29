{ lib, buildGoPackage, fetchFromGitHub, }:

buildGoPackage rec {
  name = "influxdb-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0z8y995gm2hpxny7l5nx5fjc5c26hfgvghwmzva8d1mrlnapcsyc";
  };

  goPackagePath = "github.com/influxdata/influxdb";

  excludedPackages = "test";

  # Generated with the nix2go
  goDeps = ./. + builtins.toPath "/deps-${version}.nix";

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdb.com/;
    maintainers = with maintainers; [ offline zimbatm ];
    platforms = platforms.linux;
  };
}
