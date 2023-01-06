{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1mSSnAfsg9AEnDAgINrSLIeu9O2vLqchZPSH12cjATk=";
  };

  cargoHash = "sha256-9PMBHVpf8bDuSIYKrIFZjmBE2icejPTML+hhZ4DLq/Y=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xrelkd ];
  };
}
