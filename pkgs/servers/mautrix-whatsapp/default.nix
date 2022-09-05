{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "1AcjcE57ttjypnLU/+qpPsvApiuJfSX0qbPEQKOWfIM=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "4CA/kDGohoJfdiXALN8M8fuPHQUrU2REHqVI7kKMnoY=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
