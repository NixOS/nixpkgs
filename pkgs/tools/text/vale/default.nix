{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.2.2";

  subPackages = [ "." ];
  outputs = ["out" "doc" "data"];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "11pgszm9cb65liczpnq04l1rx0v68jgmkzrw7ax5kln5hgnrh4kb";
  };

  deleteVendor = true;

  vendorSha256 = "150pvy94vfjvn74d63az917szixw1nhl60y1adixg8xqpcjnv9hj";

  goPackagePath = "github.com/errata-ai/vale";
  postInstall = ''
    mkdir -p $doc/share/doc/vale
    mkdir -p $data/share/vale
    cp -r docs/* $doc/share/doc/vale
    cp -r styles $data/share/vale
  '';

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://errata-ai.gitbook.io/vale/";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
