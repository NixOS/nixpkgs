{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kexpand-unstable-2017-05-12";

  goPackagePath = "github.com/kopeio/kexpand";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "kopeio";
    repo = "kexpand";
    rev = "c508a43a4e84410dfd30827603e902148c5c1f3c";
    sha256 = "0946h74lsqnr1106j7i2w2a5jg2bbk831d7prlws4bb2kigfm38p";
  };

  goDeps = ./deps.nix;
}
