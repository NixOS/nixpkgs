{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "bFuJa4pKwqQmpJDqYwA97CjrTeQ1Q8V/pNqD0ff6x/U=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "NTORR0ixVozUllWlGziTUSJNy1zHoPWQMZbmPUchpQ0=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
