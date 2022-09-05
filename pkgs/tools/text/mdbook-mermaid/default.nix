{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zXgXgcMF7MOa9Vx3rhv9aavqRCfMcyRLtaWEvYlyaTs=";
  };

  cargoSha256 = "sha256-sV/1caeXq/he92cvAajDL7pZJNiXCzf/DDXKnPKU4XQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
