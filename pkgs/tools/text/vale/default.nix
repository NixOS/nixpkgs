{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.4.2";

  goPackagePath = "github.com/errata-ai/vale";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "180532jp6m2ryppkjszs8b8gmvx9h54c8423par3907bgdxyzqj8";
  };

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
