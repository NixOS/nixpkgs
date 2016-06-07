{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vault-${version}";
  version = "0.5.2";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "vault";
    sha256 = "085rk5i480wdlkn2p14yxi8zgsc11595nkkda1i77c4vjkllbkdy";
  };
}
