{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "3.5.0";
  rev = "v${version}";
  
  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "getantibody";
    repo   = "antibody";
    sha256 = "0x9wfki7cl3cm9h21zj37196gwdzgllfgqmgy9n86m82wbla6slb";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage    = https://github.com/getantibody/antibody;
    license     = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
