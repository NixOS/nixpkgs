{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-I1qM1hq6bnBgbtfzgWvySairfr+Q6TthMIQM+Mregc8=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-TH353K6BOTzFC/iPIf1S7rV0DSIxjJEg42ru5H8NbSE=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
