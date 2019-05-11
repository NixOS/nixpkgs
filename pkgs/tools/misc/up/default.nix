{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "up-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
    sha256 = "1psixyymk98z52yy92lwb75yfins45dw6rif9cxwd7yiascwg2if";
  };

  goPackagePath = "github.com/akavel/up";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = https://github.com/akavel/up;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
  };
}
