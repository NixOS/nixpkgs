{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-lBseLxxk+3/eoJMdq4muOrA0TgEhwIReGtQO1OzqBFc=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-QUZ9x9BDlhoWLvdt8BTIKxHcsclT6arGICeJnOafs1g=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
