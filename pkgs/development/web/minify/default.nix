{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minify-${version}";
  version = "v2.0.0";
  rev = "41f3effd65817bac8acea89d49b3982211803a4d";

  goPackagePath = "github.com/tdewolff/minify";

  src = fetchFromGitHub {
    inherit rev;
    owner = "tdewolff";
    repo = "minify";
    sha256 = "15d9ivg1a9v9c2n0a9pfw74952xhd4vqgx8d60dhvif9lx1d8wlq";
  };

  goDeps = ./deps.json;
}
