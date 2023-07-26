{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-NbIDVBfh/6NXEvQhypOC5ToOq0EEkKKiMMahGJdXX0g=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-5S5uq7CRixw6PvtE4xz+AWfS+VsKE4+JVZjfyXmvbsM=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
