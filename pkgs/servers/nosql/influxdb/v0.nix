{ lib, buildGoPackage, fetchFromGitHub }@args:

import ./default.nix (args // rec {
  
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0f7af5jb1f65qnslhc7zccml1qvk6xx5naczqfsf4s1zc556fdi4";
  };
}) 
