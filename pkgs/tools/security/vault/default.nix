{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vault-${version}";
  version = "0.6.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "vault";
    sha256 = "0byb91nqrhl7w0rq0ilml1ybamh8w1qga47a790kggsmjhcj9ybx";
  };
}
