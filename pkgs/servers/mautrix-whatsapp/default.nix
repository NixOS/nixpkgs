{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-9o8AjZclSVzpAIqnW28/iaP10pA5cg7eC1q/kbMI3jI=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-Gnr3+653gy3C8G0NSYsjsQFkfDPs013pyl/ARD5yweM=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
