{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-elDKxtGMLka9Ss5CNnzw32ndxTUliNUgPXp7e4KUmBo=";
  };

  cargoHash = "sha256-BnbllOsidqDEfKs0pd6AzFjzo51PKm9uFSwmOGTW3ug=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Preprocessor for mdbook to add mermaid.js support";
    mainProgram = "mdbook-mermaid";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xrelkd matthiasbeyer ];
  };
}
