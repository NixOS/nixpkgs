{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "adsGPVG/EwpzOqhFJvn3anjTXwGY27a7Bc4NNkBeqJk=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-f2sHMUvS8maYms8eqeQe5ez6G234CkLASIuKolqhO4k=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
