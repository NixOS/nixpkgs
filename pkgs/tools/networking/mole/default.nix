{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "mole";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davrodpin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JwLiuw00g2h5uqNmaqAbal0KCY6LwF2fcL2MrB1HBIc=";
  };

  vendorHash = "sha256-+y9JiQvDSQS5WQD4mVOMH3Oh9C4C/Kx3kC6q2SgSo+I=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/davrodpin/mole/cmd.version=${version}"
  ];

  meta = with lib; {
    description = "CLI application to create SSH tunnels";
    homepage = "https://github.com/davrodpin/mole";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin; # build fails with go > 1.17
    mainProgram = "mole";
  };
}
