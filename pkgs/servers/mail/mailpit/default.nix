{ lib
, buildGoModule
, nodejs
, python3
, libtool
, npmHooks
, fetchFromGitHub
, fetchNpmDeps
}:

buildGoModule rec {
  pname = "mailpit";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = "sha256-jT9QE0ikp9cJlT8qtfPPjKOUuqWyQk94D3UbkyaGXa8=";
  };

  vendorHash = "sha256-XBYIO7fdo5EahJB7EcAuY9SGKZb8dsvoJHp/D5LO5Qo=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-6VCs8125fTJkZW+eZgK56j7ccK8tcGhIXiq2HkYp4XM=";
  };

  nativeBuildInputs = [ nodejs python3 libtool npmHooks.npmConfigHook ];

  preBuild = ''
    npm run package
  '';

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X github.com/axllent/mailpit/config.Version=${version}" ];

  meta = with lib; {
    description = "An email and SMTP testing tool with API for developers";
    homepage = "https://github.com/axllent/mailpit";
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    maintainers = with maintainers; [ stephank ];
    license = licenses.mit;
  };
}
