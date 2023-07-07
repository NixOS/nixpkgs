{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-F2PrBlS9uL6BQtjNNabCpl3ofavsUGlBy/Hotm42Oec=";
  };

  cargoHash = "sha256-aeXvqgSKRvm9W6sc5XCkwhMYUncj8pEPyQpYQr+fj7Y=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
