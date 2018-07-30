{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "3.5.1";
  rev = "v${version}";
  
  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "getantibody";
    repo   = "antibody";
    sha256 = "0bqq59vnnm80jiqlhn7wfyzj96nkv8k9zp8i4sgcj8gvk1zq2lbc";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage    = https://github.com/getantibody/antibody;
    license     = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
