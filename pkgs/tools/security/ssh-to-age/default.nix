{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-vER4PG2LFi/NM9TmCffqsF3aR4ZycwWVeKls2fNupo0=";
  };

  vendorHash = "sha256-g8qVV2cd7nxBN/BGNz28gJbtNkCUDJDdSdupXxhFw9Q=";

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys in ed25519 format to age keys";
    homepage = "https://github.com/Mic92/ssh-to-age";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "ssh-to-age";
  };
}
