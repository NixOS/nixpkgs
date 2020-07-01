{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vale";
  version = "2.0.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "068973ayd883kzkxl60lpammf3icjz090nw07kfccvhcf24x07bh";
  };

  goPackagePath = "github.com/errata-ai/vale";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://errata-ai.gitbook.io/vale/";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
