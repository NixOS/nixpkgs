{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-GWtci/OiipaUFzzha3GvkoKmN1lb9Fg3i+X1ZFkGKtc=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-IEBSY61Bjuc42GqQUvChqLayO1hiDEDBxlMoAKJo12E=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
