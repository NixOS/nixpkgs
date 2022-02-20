{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "lBAnMrU292URrZIxPvPIAO50GAFvvZHfUjKMYxZwGb8=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "KiNABUZ92gYprTdNAKKMjygr0BzQGVYVPRPMxvYi1VQ=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
