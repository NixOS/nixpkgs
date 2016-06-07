{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-template-${version}";
  version = "0.14.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul-template";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "consul-template";
    sha256 = "15zsax44g3dwjmmm4fpb54mvsjvjf3b6g3ijskgipvhcy0d3j938";
  };
}
