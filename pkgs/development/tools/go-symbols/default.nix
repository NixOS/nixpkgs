{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "go-symbols-${version}";
  version = "unstable-2017-02-06";
  rev = "5a7f75904fb552189036c640d04cd6afef664836";

  goPackagePath = "github.com/acroca/go-symbols";
  goDeps = ./deps.nix;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/acroca/go-symbols";
    sha256 = "0qh2jjhwwk48gi8yii0z031bah11anxfz81nwflsiww7n426a8bb";
  };

  meta = {
    description = "A utility for extracting a JSON representation of the package symbols from a go source tree.";
    homepage = https://github.com/acroca/go-symbols;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
