{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.10.0";

  vendorSha256 = "sha256-cKHX/GnvGELQBfoo0/1UmDQ4Z66GGnnHG7+1CzjinL0=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-12Jac+mXWdUX8gWvmpdO9ROv7Bi0YzvyqnNDVNJOr34=";
  };

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
