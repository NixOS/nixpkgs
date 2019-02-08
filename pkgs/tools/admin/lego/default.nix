{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "lego-${version}";
  version = "2.0.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "xenolf";
    repo = "lego";
    sha256 = "17q5j2zxc2c0xw8pfhnls67dmwrkicjmd2jdyim3fhi5cgxl9h93";
  };

  goPackagePath = "github.com/xenolf/lego";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = https://github.com/xenolf/lego;
    maintainers = with maintainers; [ andrew-d ];
  };
}
