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

  cargoSha256 = "sha256-zdvIC+VUASjhrlyRts+JJeh5xdcdpX6Ixle6HhbMJJU=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}
