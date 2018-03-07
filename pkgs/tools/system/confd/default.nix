{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "confd-${version}";
  version = "0.11.0";
  rev = "v${version}";

  goPackagePath = "github.com/kelseyhightower/confd";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "kelseyhightower";
    repo = "confd";
    sha256 = "0l8z688xs89bar4bifjxis4pa9z8c23z70bczw7y30nclp7m46z2";
  };

  goDeps = ./deps.nix;
}
