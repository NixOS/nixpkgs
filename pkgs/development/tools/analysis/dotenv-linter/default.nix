{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-3Lj5GtWGyWDkZPhxYQu7UWzmh7TO5wk1UJ0lek1jTto=";
  };

  cargoSha256 = "sha256-FDkxJuZPzDrgLJgefkRUPS+0Ys3DaBOD3XAuS/Z6TtI=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}
