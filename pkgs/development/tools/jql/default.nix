{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1bwgG3VkIPU6lVl4OQNIaHNj7OXhTeMfAjQK2SMypZ8=";
  };

  cargoSha256 = "sha256-VUrDrPVL2KkK1HA/iq8VBzEJSDzRvUfQ+9C8MuSfvkQ=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
