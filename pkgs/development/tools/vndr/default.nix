{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vndr-${version}";
  version = "20171005-${lib.strings.substring 0 7 rev}";
  rev = "b57c5799efd5ed743f347a025482babf01ba963e";

  goPackagePath = "github.com/LK4D4/vndr";
  excludedPackages = "test";

  src = fetchFromGitHub {
    inherit rev;
    owner = "LK4D4";
    repo = "vndr";
    sha256 = "15mmy4a06jgzvlbjbmd89f0xx695x8wg7jqi76kiz495i6figk2v";
  };

  meta = {
    description = "Stupid golang vendoring tool, inspired by docker vendor script";
    homepage = https://github.com/LK4D4/vndr;
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
