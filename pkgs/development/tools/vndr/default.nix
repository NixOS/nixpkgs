{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vndr-${version}";
  version = "20170511-${lib.strings.substring 0 7 rev}";
  rev = "0cb33a0eb64c8ca73b8e2939a3430b22fbb8d3e3";

  goPackagePath = "github.com/LK4D4/vndr";
  excludedPackages = "test";

  src = fetchFromGitHub {
    inherit rev;
    owner = "LK4D4";
    repo = "vndr";
    sha256 = "02vdr59xn79hffayfcxg29nf62rdc33a60i104fgj746kcswgy5n";
  };

  meta = {
    description = "Stupid golang vendoring tool, inspired by docker vendor script";
    homepage = "https://github.com/LK4D4/vndr";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
