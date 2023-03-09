{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-0hnBqYwFVVlqv+8Cx2qvytDU6I+MPWQIpG4nYd7mPLM=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-n3DBPI1gjbmP9m+xkGVoTSBcA0ELSokNZb9i3cYmAqc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
