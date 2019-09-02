{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "antibody";
  version = "4.1.0";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "027qh535cpk5mbxav199vvzhwfkcs0lm7skgfhshpzps1yw4w4mb";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
