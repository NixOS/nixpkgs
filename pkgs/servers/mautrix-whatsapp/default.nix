{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "lBAnMrU292URrZIxPvPIAO50GAFvvZHfUjKMYxZwGb8=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-wenJP6DC/POEtFDbUFOIuVz1fN0LVXZFvs2e2KvrsQM=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
