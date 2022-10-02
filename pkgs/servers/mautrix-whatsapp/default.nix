{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-OUGFp25M8wn8eWMuQHDh8Zp67x+VHVbyvuBHq+UE+NY=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-9pOe7jHgyrFP1Sj8O1KEVxcEaUPEE0+41HUfQoPxa2E=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
