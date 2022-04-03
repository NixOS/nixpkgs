{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U++yypq9M1C6Sh9rv3rmn/qwTXWdPFDBpjFS6eoS2L4=";
  };

  cargoSha256 = "sha256-uyD+QBDfnZa3nfZcUAqruYqJ9nVAa5+XOPONds0ysXU=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
