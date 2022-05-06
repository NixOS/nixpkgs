{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wokdlmczClYwVskBDpKQyka1GiLf4JvRiooK+qo7Tv4=";
  };

  cargoSha256 = "sha256-6L78LxxzqkjP9k71WmZhkhNVdKLXUwSYioKynaETTaA=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
