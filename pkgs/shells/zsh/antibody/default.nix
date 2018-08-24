{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "3.6.1";
  rev = "v${version}";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "getantibody";
    repo   = "antibody";
    sha256 = "1xlaf3440hs1ffa23ja0fc185sj0rxjv0808ib8li3rq2qfkd0k8";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage    = https://github.com/getantibody/antibody;
    license     = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
