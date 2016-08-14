{ lib, buildGoPackage, fetchFromGitHub, src, version }:

buildGoPackage rec {
  name = "influxdb-${version}";

  goPackagePath = "github.com/influxdata/influxdb";

  excludedPackages = "test";
  
  inherit src;

  # Generated with the `gdm2nix.rb` script and the `Godeps` file from the
  # influxdb repo root.
  goDeps = ./. + builtins.toPath "/deps-${version}.json";

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdb.com/;
    maintainers = with maintainers; [ offline zimbatm ];
    platforms = platforms.linux;
  };
}
