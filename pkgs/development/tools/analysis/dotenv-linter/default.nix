{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-kBBn8Lgb3427K00Ag35Ei9oBD7L0Zp/lr0cAKqZpULo=";
  };

  cargoSha256 = "sha256-7Porqqh6lYeBCK2pAtbL9nxtORB9rqSyVdJDoy1/ZDo=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}
