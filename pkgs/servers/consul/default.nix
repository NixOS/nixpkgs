{ stdenv, lib, buildGoPackage, consul-ui, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-${version}";
  version = "0.7.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    inherit rev;
    sha256 = "04h5y5vixjh9np9lsrk02ypbqwcq855h7l1jlnl1vmfq3sfqjds7";
  };

  # Keep consul.ui for backward compatability
  passthru.ui = consul-ui;
}
