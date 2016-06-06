{ stdenv, lib, buildGo16Package, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGo16Package rec {
  name = "caddy-${version}";
  version = "0.8.3";
  rev = "e2234497b79603388b58ba226abb157aa4aaf065";

  goPackagePath = "github.com/mholt/caddy";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mholt/caddy";
    sha256 = "1snijkbz02yr7wij7bcmrj4257709sbklb3nhb5qmy95b9ssffm6";
  };

  goDeps = ./deps.json;
}
