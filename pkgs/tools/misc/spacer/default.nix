{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-eFXxcOhUqyo3eUws3RCO0w+0XGlxZAonKFTphnrhHs8=";
  };

  cargoHash = "sha256-z7igJc8HHqpiY2an4hFWoZElwgF5NUA+TFPqxuowC/w=";

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
