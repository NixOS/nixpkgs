{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "atlas";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    sha256 = "1wxfji28r100qnmryfixhg2n2mcvvl65vv50fqzhh2q576c0sh5h";
  };

  goPackagePath = "ariga.io/atlas";
  goDeps = ./deps.nix;
  subPackages = [ "cmd/atlas" ];

  meta = with lib; {
    description = "A database toolkit";
    homepage = "https://atlasgo.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ akirak ];
  };
}
