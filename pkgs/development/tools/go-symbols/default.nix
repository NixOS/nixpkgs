{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-symbols-${version}";
  version = "unstable-2018-05-23";
  rev = "953befd75e223f514580fcb698aead0dd6ad3421";

  goPackagePath = "github.com/acroca/go-symbols";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "acroca";
    repo = "go-symbols";
    sha256 = "0dwf7w3zypv5brk68n7siakz222jwnhrhkzvwk1iwdffk79gqp3x";
  };

  meta = {
    description = "A utility for extracting a JSON representation of the package symbols from a go source tree.";
    homepage = https://github.com/acroca/go-symbols;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
