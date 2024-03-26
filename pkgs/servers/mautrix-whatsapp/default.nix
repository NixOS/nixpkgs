{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-foYmHJk25SOCv+o6eiJTeD2VP8vi6PpeeDm845Lq43Y=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-2xHgGBVFzEnOFiZrg1ClgjUrzKVD3CLxPsvRO2iQBC4=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
    mainProgram = "mautrix-whatsapp";
  };
}
