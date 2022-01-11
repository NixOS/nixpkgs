{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-maYFOlWNqKFmyDM2nDF25rzYnUXMlV9Ry9TMoXReUUg=";
  };

  cargoSha256 = "sha256-GL5Z4KfRu0zQAzVCWRIhaYtG5FrDdQabsbyFX7SjZvg=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
