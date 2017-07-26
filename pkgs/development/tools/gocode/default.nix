{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gocode-${version}";
  version = "20170530-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "f1eef9a6ba005abb145d7b58fdd225e83a3c6a05";

  goPackagePath = "github.com/nsf/gocode";

  # we must allow references to the original `go` package,
  # because `gocode` needs to dig into $GOROOT to provide completions for the
  # standard packages.
  allowGoReference = true;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/nsf/gocode";
    sha256 = "1hkr46ikrprx203i2yr6xds1bzxggblh7bg026m2cda6dxgpnsgw";
  };
}
