{ stdenv, go, git, fetchgit, buildGoPackage }:

buildGoPackage rec {
  name = "keto-unstable-${version}";
  version = "2019-01-03";
  rev = "ed7af3fa4e5d1d0d03b5366f4cf865a5b82ec293";

  goPackagePath = "github.com/ory/keto";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/ory/keto";
    sha256 = "1l4wknqj5p21djz96b5bdx373dr2cjg2rd9r8q9irl0wrakk36pp";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
     homepage = https://ory.sh/;
     description = "Cloud Native Access Control.";
     maintainers = with maintainers; [ ingenieroariel ];
     platforms = platforms.unix;
     license = licenses.asl20;
   };
}
