{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.3.1";
  goPackagePath = "github.com/drone/drone";

  modSha256 = "128nnn8axnr30y3r46d11g8qznbsg82z2qw9qbxkq3bja6nz8fn2";

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "0vp86k1z3r79sx0ln3vndzx8ycf0dbiv7jk56ncmk390iiz2a4g4";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
