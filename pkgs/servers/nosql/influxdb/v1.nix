{ lib, buildGoPackage, fetchFromGitHub }@args:

import ./default.nix (args // rec {
  
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0z8y995gm2hpxny7l5nx5fjc5c26hfgvghwmzva8d1mrlnapcsyc";
  };
}) 
