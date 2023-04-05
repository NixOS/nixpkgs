{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-rSyKKWg9PiAZAdmUfWWxU4ZXGHP+LR1kcDXMbkB3wYA=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-eHY6YBPDA2uJyhvB/3bd+W2PEfGjyx3BEAlbJvVV0Yo=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
