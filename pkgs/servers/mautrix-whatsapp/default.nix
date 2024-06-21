{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-zig3JKeOD5uJj5GcQqGwiC/RqaviPSnqM/a3nivt1/c=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-Rik1LTaoqW50Jhm8FXqX6N+Q7oKd6Nn+dJQKcAUDmb8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
    mainProgram = "mautrix-whatsapp";
  };
}
