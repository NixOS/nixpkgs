{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "2F0smK2L9Xj3/65j7vwwGT1OLxcTqkImpn16wB5rWDw=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "Xv+3dJLOHnOjTp5vDbejmkO/NoDQlWxl0KaMx1C3ch0=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
