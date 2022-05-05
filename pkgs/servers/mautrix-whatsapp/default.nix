{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "adsGPVG/EwpzOqhFJvn3anjTXwGY27a7Bc4NNkBeqJk=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "WT8oDtmUFrqfNK/RnEv8+jpGuQEGt+ppjtmcfUGYZv0=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
