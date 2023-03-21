{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-kroki-preprocessor";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "joelcourtney";
    repo = "mdbook-kroki-preprocessor";
    rev = "v${version}";
    hash = "sha256-1TJuUzfyMycWlOQH67LR63/ll2GDZz25I3JfScy/Jnw=";
  };

  cargoHash = "sha256-IKwDWymAQ1OMQN8Op+DcvqPikoLdOz6lltbhCgOAles=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Render Kroki diagrams from files or code blocks in mdbook";
    homepage = "https://github.com/joelcourtney/mdbook-kroki-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ blaggacao ];
  };
}
