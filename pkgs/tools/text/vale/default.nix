{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.2.6";

  goPackagePath = "github.com/errata-ai/vale";

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "1mhynasikncwz9dkk9z27qvwk03j7q0vx0wjnqg69pd97lgrp7zp";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "Vale is an open source linter for prose";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
