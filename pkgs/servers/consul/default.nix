{ stdenv, lib, buildGo16Package, consul-ui, fetchFromGitHub }:

buildGo16Package rec {
  name = "consul-${version}";
  version = "0.6.4";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    inherit rev;
    sha256 = "0p6m2rl0d30w418n4fzc4vymqs3vzfa468czmy4znkjmxdl5vp5a";
  };

  # Keep consul.ui for backward compatability
  passthru.ui = consul-ui;
}
