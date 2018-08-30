{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gocode-${version}";
  version = "20170903-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "c7fddb39ecbc9ebd1ebe7d2a3af473ed0fffffa1";

  goPackagePath = "github.com/nsf/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/nsf/gocode";
    sha256 = "0qx8pq38faig41xkl1a4hrgp3ziyjyn6g53vn5wj7cdgm5kk67nb";
  };
}
