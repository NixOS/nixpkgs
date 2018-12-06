{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "pgcenter-${version}";
  version = "0.5.0";

  goPackagePath = "github.com/lesovsky/pgcenter";

  src = fetchFromGitHub {
    owner  = "lesovsky";
    repo   = "pgcenter";
    rev    = "v${version}";
    sha256 = "1bbpzli8hh5356gink6byk085zyfwxi8wigdy5cbadppx4qnk078";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://pgcenter.org/;
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
