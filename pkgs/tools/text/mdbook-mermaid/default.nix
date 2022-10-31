{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1w132lpkn0m2ZoMyFKFGjwn9Gd3UDksEKr5vq8l4ANQ=";
  };

  cargoHash = "sha256-OKE8RcCE4pIRtQDW7KNzUVrNpyZzWg6QHchJg0XWmYQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
