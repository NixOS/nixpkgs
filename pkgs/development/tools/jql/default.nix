{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V7JLoXYhCCh2XfNE7ry/us4b/NsoieFls88ewuyrN08=";
  };

  cargoHash = "sha256-+H9KlzrVZSAfzmdw3chJYHg2fbctIs9xCIqHk4ZJzOM=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
