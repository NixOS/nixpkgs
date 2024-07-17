{
  lib,
  buildGoPackage,
  fetchFromGitHub,
}:

buildGoPackage rec {
  pname = "vndr-unstable";
  version = "2020-07-28";
  rev = "f12b881cb8f081a5058408a58f429b9014833fc6";

  goPackagePath = "github.com/LK4D4/vndr";
  excludedPackages = "test";

  src = fetchFromGitHub {
    inherit rev;
    owner = "LK4D4";
    repo = "vndr";
    sha256 = "04za4x8p8qzwjlp4i0j0gsb4xx0x9f4yp3ab0b97r50pah1ac2g3";
  };

  meta = {
    description = "Stupid golang vendoring tool, inspired by docker vendor script";
    mainProgram = "vndr";
    homepage = "https://github.com/LK4D4/vndr";
    maintainers = with lib.maintainers; [
      vdemeester
      rvolosatovs
    ];
    license = lib.licenses.asl20;
  };
}
