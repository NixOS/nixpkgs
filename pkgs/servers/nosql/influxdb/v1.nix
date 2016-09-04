{ lib, buildGoPackage, fetchFromGitHub }@args:

import ./default.nix (args // rec {
  
  version = "1.0.0-beta3";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "1hj9wl2bfd1llc11jrv8bq18wl2y9n6fl3w6052wb530j7gsivsq";
  };
}) 
