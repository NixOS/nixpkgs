{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "3.4.6";
  rev = "v${version}";
  
  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "getantibody";
    repo   = "antibody";
    sha256 = "0pvsngvlxv5iw7yj18snslag8c61ji4w3j3rw543ckl6k3f9zq6c";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage    = https://github.com/getantibody/antibody;
    license     = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
