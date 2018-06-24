{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-alerts-${version}";
  version = "0.5.0";
  rev = "v${version}";

  goPackagePath = "github.com/AcalephStorage/consul-alerts";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "0dff2cpk3lkgjsh97rvlrpacpka0kwm29691diyvj7lb9ydzlx3r";
  };
}
