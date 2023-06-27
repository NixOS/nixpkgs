{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-+uMpAsIadkdUrKkAr6ejOc1NfRIISA2R0AOjIXGXVpY=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-emUCf6ZKFjBDr5WEKzYfbBNR44FDbjedmCgHfkjHQtw=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
