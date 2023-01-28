{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-fLYc0Z9lgNYjv4D+TpKP1+sBuILV1lf1IEDRYc8fUY4=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-RUTImaiiCsNHZHGTAXPXySP3tlEUJr6DLhmNA3ubgFs=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
