{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Jj3mbsH/rFrUTWcgT4+KQJ2Bae58STHBB+7oZwbrhLk=";
  };

  cargoHash = "sha256-a2JGpIvI65djxyB1LZFWgIQmhsLPLhiYkyvqKwysgQo=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman matthiasbeyer ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
