{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "pgcenter";
  version = "0.6.1";

  goPackagePath = "github.com/lesovsky/pgcenter";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "12wyi6vc3i0dq76mrvv5r632ks90xppcra5g7rjf54vg4291kycy";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://pgcenter.org/;
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
