{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-iVILI6OGndnxIVmgNcIwHA64tkv9V3OTH3YtrCyeYx4=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-DpgkSXSLF+U6zIzJ4AF2uTcFWQQYsRgkaUTG9F+bnVk=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
    mainProgram = "mautrix-whatsapp";
  };
}
