{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.3.0";

  goPackagePath = "github.com/errata-ai/vale";

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "1yfrn27z3ifdlvalgrnhdrkhxkh09xpyv681sr01wc2hxq6v3hqn";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
