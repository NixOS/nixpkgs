{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mmark";
  version = "1.3.6";
  rev = "v${version}";

  goPackagePath = "github.com/miekg/mmark";

  src = fetchFromGitHub {
    inherit rev;
    owner = "miekg";
    repo = "mmark";
    sha256 = "0q2zrwa2vwk7a0zhmi000zpqrc01zssrj9c5n3573rg68fksg77m";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A powerful markdown processor in Go geared towards the IETF";
    homepage = https://github.com/miekg/mmark;
    license = with stdenv.lib.licenses; bsd2;
    maintainers = with stdenv.lib.maintainers; [ yrashk ];
    platforms = stdenv.lib.platforms.unix;
  };
}
