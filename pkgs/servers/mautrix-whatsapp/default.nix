{ lib, stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "sha256-RkMgzYu6r30uqUCtCS/FuvJQiTInRYWiWhlTtDQQh5g=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-p6TW5ACXjqCR5IAVleMEIWYW4SHI1ZRL5KJFZpPc7yU=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
