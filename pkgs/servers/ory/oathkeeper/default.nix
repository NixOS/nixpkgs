{ stdenv, go, git, fetchgit, buildGoPackage }:

buildGoPackage rec {
  name = "oathkeeper-unstable-${version}";
  version = "2019-01-03";
  rev = "2d9899a38b927ff367931c024a10bfdc3230e9a3";

  goPackagePath = "github.com/ory/oathkeeper";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/ory/oathkeeper";
    sha256 = "03ss3i3fz4skppfin36bzikjgsrys46api68qpj4rw3w7m4af0jk";
  };

  goDeps = ./deps.nix;
  meta = with stdenv.lib; {
     homepage = https://ory.sh/;
     description = "Zero Trust Identity & Access Proxy.";
     maintainers = with maintainers; [ ingenieroariel ];
     platforms = platforms.unix;
     license = licenses.asl20;
   };

}
