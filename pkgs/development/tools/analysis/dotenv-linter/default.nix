{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-YWL1aPcMdU4lo7h/T2sdl2H6qnx3lfMtV39Ak4yP88w=";
  };

  cargoSha256 = "sha256-q59hpnXc00OzrJk1KOWbIPQYfIE+7ku9XtTDXHgwQBg=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}
