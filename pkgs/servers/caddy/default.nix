{ stdenv, lib, buildGoPackage, fetchFromGitHub, fetchgit }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.8.3";
  rev = "e2234497b79603388b58ba226abb157aa4aaf065";

  goPackagePath = "github.com/mholt/caddy";

  src = fetchFromGitHub {
    inherit rev;
    owner = "mholt";
    repo = "caddy";
    sha256 = "1snijkbz02yr7wij7bcmrj4257709sbklb3nhb5qmy95b9ssffm6";
  };

  goDeps = import ./deps.nix { inherit fetchgit; };
}
