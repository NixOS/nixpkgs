{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-22JmV4cFfUTwiweQP0Em2VbqmTUui2yWnbhKagprQ4Q=";
  };

  cargoHash = "sha256-tztzmfWOtqFGWERMWgBSAqvT+hKfhBWL9KW4awixXk0=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
