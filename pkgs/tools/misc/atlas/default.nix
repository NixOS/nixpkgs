{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "atlas";
  version = "0.3.3";
  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    sha256 = "18ilqrnhm48bi511l9wb2vhcyyp12ajn9ks4s3jk567v0j8bph6b";
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
