{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-XiDuH4W5yghbT2wIcqcC2y1qJH62mWvTk6ca3KedkIk=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-m9wB6u76ONw0+mZeCnwEYOqBvghil+rcKUJFKRaT5Nk=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
