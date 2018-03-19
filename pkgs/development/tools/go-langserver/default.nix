{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-langserver-${version}";
  version = "unstable-2018-03-05";
  rev = "5d7a5dd74738978d635f709669241f164c120ebd";

  goPackagePath = "github.com/sourcegraph/go-langserver";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "sourcegraph";
    repo = "go-langserver";
    sha256 = "0aih0akk3wk3332znkhr2bzxcc3parijq7n089mdahnf20k69xyz";
  };

  meta = with stdenv.lib; {
    description = "A Go language server protocol server";
    homepage = https://github.com/sourcegraph/go-langserver;
    license = licenses.mit;
    maintainers = with maintainers; [ johnchildren ];
    platforms = platforms.unix;
  };
}
