{ stdenv, lib, buildGoPackage, consul-ui, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-${version}";
  version = "0.7.3";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    inherit rev;
    sha256 = "0ab84sm281ibl9h6zfk17mr7yc9vxpi8i2xb4kzi8bg43n05lj4d";
  };

  # Keep consul.ui for backward compatability
  passthru.ui = consul-ui;
}
