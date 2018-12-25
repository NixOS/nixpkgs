{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "antibody-${version}";
  version = "4.0.2";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    owner  = "getantibody";
    repo   = "antibody";
    rev = "v${version}";
    sha256 = "1lq0bd2l928bgwqiq3fa5ippjhnsfgwdqn6nd3hfis8bijrwc5jv";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
