{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-W+5DtCp7P/0azfusv+Nt3G9VcWKPUxVJmNwSfPjxjbw=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-Fr7yVTl8PIdr+SxXhUKG9DS18762HqL9ap6sUM3ziCQ=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
