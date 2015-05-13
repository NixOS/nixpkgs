{ goPackages, fetchurl, callPackage }:

with goPackages;
let
  oglematchers = callPackage ./oglematchers.nix {};
in
buildGoPackage rec {
  version = "1.4.0";
  name = "assertions-${version}";
  goPackagePath = "github.com/smartystreets/assertions";
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/smartystreets/assertions/archive/${version}.tar.gz";
    sha256 = "1y2rxgj2mj4lqwhbn20ipavh7ap5py1lfpf5kmkb9d3ia2h16sz3";
  };
  subPackages = [ "reporting" ];
  # goTestInputs = [ ogletest ];
  doCheck = false;
}
