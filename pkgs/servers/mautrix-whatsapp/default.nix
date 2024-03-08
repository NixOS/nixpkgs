{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-bn9nUTtpaEkzF2SEdCcKG27WQDL7xsgfgA/72wElQqA=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-PDUSjza+0SDanQwKYQRuLzsiA/sHjRnG0xpzlzhkm+U=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
    mainProgram = "mautrix-whatsapp";
  };
}
