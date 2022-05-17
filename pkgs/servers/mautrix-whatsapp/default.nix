{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "2F0smK2L9Xj3/65j7vwwGT1OLxcTqkImpn16wB5rWDw=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-BEjUOeD5Db5o9gG5BDmYkbWMAiz9rQtqIwoUo21pQDs=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
