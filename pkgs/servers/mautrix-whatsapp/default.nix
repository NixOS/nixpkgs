{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-KeuAxrp4DYy0+K1XYF3FxindYoOHHfwtufwKnic46i8=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-oxRxGxYvpO1TeEBAKO1RDwqw4NUSW4XunGdVB6zXjx8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
