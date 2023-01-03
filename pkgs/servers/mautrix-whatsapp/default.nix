{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-shCFKTS6ArvjecokNSrgOBr5jO+64+d6OdubTHOWiws=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-BD1DBzr8iwVq2Qe7Zz1i871ysAYJ7iUlcBftjDYreeM=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
