{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vault-${version}";
  version = "0.5.3";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "vault";
    sha256 = "0px9l5zkvqawzsss70g58fx1anrx5zsdgxl6iplv0md111h0d87z";
  };
}
