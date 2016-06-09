{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nsq-${version}";
  version = "0.3.5";
  rev = "v${version}";

  goPackagePath = "github.com/bitly/nsq";

  src = fetchFromGitHub {
    inherit rev;
    owner = "bitly";
    repo = "nsq";
    sha256 = "1r7jgplzn6bgwhd4vn8045n6cmm4iqbzssbjgj7j1c28zbficy2f";
  };

  goDeps = ./deps.json;
}
