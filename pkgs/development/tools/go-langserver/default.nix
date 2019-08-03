{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-langserver";
  version = "2.0.0";

  goPackagePath = "github.com/sourcegraph/go-langserver";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sourcegraph";
    repo = "go-langserver";
    sha256 = "1wv7xf81s3qi8xydxjkkp8vacdzrq8sbj04346fz73nsn85z0sgp";
  };

  meta = with stdenv.lib; {
    description = "A Go language server protocol server";
    homepage = https://github.com/sourcegraph/go-langserver;
    license = licenses.mit;
    maintainers = with maintainers; [ johnchildren ];
    platforms = platforms.unix;
  };
}
