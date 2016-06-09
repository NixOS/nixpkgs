{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "lint-${version}";
  version = "20160428-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "c7bacac2b21ca01afa1dee0acf64df3ce047c28f";
  
  goPackagePath = "github.com/golang/lint";
  excludedPackages = "testdata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/golang/lint";
    sha256 = "024dllcmpg8lx78cqgq551i6f9w6qlykfcx8l7yazak9kjwhpwjg";
  };

  goDeps = ./deps.json;
}
