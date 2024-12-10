{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "backdown";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "backdown";
    rev = "v${version}";
    hash = "sha256-w9EdDSGqmHRLXwx5qFo0BngKATKtQsieMt6dPgfOrQ0=";
  };

  cargoHash = "sha256-BOwhXq/xVuk3KylL3KeIkiIG3SXVASFiYkUgKJhMzuU=";

  meta = with lib; {
    description = "A file deduplicator";
    homepage = "https://github.com/Canop/backdown";
    changelog = "https://github.com/Canop/backdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "backdown";
  };
}
