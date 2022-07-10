{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "xKj1iKKzFQFjzXZGqoCDyuwXs55QNmnPdojgxy0dQTY=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "svpUQQI9dDNQoL+LDoxhEch7dtNd20ojG3YHga1r15c=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
