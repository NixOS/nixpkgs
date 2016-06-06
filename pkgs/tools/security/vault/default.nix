{ stdenv, lib, buildGo16Package, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGo16Package rec {
  name = "vault-${version}";
  version = "0.5.2";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hashicorp/vault";
    sha256 = "085rk5i480wdlkn2p14yxi8zgsc11595nkkda1i77c4vjkllbkdy";
  };
}
