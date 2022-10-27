{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d2DETEASOe73mpyuk5NZzSzKln1LPttCbnmWEiFnAks=";
  };

  cargoSha256 = "sha256-se5tGgZysetH4dlh+oe41FRhVqFQIw218fEKwqa3WCA=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
