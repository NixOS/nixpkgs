{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Qyt5N6Fito++5lpjDXlzupmguue9kc409IpaDkIRgxw=";
  };

  cargoHash = "sha256-ji38ZNOZ+SDL7+9dvaRIA38EsqMqYWpSmZntexJqcMU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    mainProgram = "mdbook-mermaid";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xrelkd matthiasbeyer ];
  };
}
