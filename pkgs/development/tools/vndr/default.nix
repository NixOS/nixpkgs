{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vndr-unstable";
  version = "2018-06-23";
  rev = "81cb8916aad3c8d06193f008dba3e16f82851f52";

  goPackagePath = "github.com/LK4D4/vndr";
  excludedPackages = "test";

  src = fetchFromGitHub {
    inherit rev;
    owner = "LK4D4";
    repo = "vndr";
    sha256 = "0c0k0cic35d1141az72gbf8r0vm9zaq4xi8v1sqpxhlzf28m297l";
  };

  meta = {
    description = "Stupid golang vendoring tool, inspired by docker vendor script";
    homepage = "https://github.com/LK4D4/vndr";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
