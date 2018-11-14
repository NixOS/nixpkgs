{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "up-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
    sha256 = "171bwbk2c7jbi51xdawzv7qy71492mfs9z5j0a5j52qmnr4vjjgs";
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
