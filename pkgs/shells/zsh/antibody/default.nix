{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "3.7.0";
  rev = "v${version}";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "getantibody";
    repo   = "antibody";
    sha256 = "1c7f0b1lgl4pm3cs39kr6dgr19lfykjhamg74k5ryrizag0j68l5";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage    = https://github.com/getantibody/antibody;
    license     = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
