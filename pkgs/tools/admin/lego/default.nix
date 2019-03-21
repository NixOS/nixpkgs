{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "lego-${version}";
  version = "2.2.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "xenolf";
    repo = "lego";
    sha256 = "1bb4kjkbphay63z83a4z2859qrlrx2h7n3rgia17fhy38xp5zzqp";
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
