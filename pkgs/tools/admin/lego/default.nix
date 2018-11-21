{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "lego-${version}";
  version = "1.2.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "xenolf";
    repo = "lego";
    sha256 = "1b2cv78v54afflz3gfyidkwzq7r2h5j45rmz0ybps03pr0hs4gk3";
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
