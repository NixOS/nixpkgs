{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-uouxOXvVbUNRHM83JearPhMTZQtMPEBfWvsVb7QJSO8=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-dgaI/gpngCcVRVK8SK6ac1hmc7/aYLJCnW2CCYRDXy0=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
