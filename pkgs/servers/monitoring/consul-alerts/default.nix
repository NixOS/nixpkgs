{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-alerts-${version}";
  version = "0.3.3";
  rev = "v${version}";

  goPackagePath = "github.com/AcalephStorage/consul-alerts";

  src = fetchFromGitHub {
    inherit rev;
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "1w0mb20w1yazyh84sa30bsw271c5nm7lsx2qg0g3gf6mxdb63lpq";
  };
}
