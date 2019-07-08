{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.5.0";

  goPackagePath = "github.com/errata-ai/vale";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "04j9l478dx3irdp7nyx6rdjpgra7y8bg5smyvq0qmc256h5hy4k0";
  };

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
