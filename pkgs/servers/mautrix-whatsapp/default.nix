{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "DKW54bxhohvtz71zqFi4ZacK1pVys6aR5B9naD7PYPk=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "Y9mUl7fWZiXBEEDX3w2HXMlQKJntv16WeQC1bQQ7hHs=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
