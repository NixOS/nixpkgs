{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-11-04";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "f53975cc91e3c643a722adf0d3e0dfb98d0127a2";
    hash = "sha256-xUALcN5oQfwC6gmOeygCkOAXJrJzNitBxHRFAKKgFvE=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-yday2mSnPwuhXWkCG4XY7qoBl3DXHcSvzBoZbjgYz/c=";

  ldflags = [ "-s" "-w" ]; # https://github.com/NixOS/nixpkgs/issues/177698

  doCheck = false; # No tests available

  meta = with lib; {
    homepage = "https://go.mau.fi/mautrix-discord";
    description = "Matrix to Discord hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ robin ];
  };
}
