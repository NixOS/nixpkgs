{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-4eqgmJ5CC1Glc8jG+4cQs6FbrY8Az29rCrZvFU3PAoM=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-Y9mUl7fWZiXBEEDX3w2HXMlQKJntv16WeQC1bQQ7hHs=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
