{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ybcX2dm+gnvhWAcraCq22uGqe8NdqNd8QMNKVkqgNqY=";
  };

  cargoHash = "sha256-GzRxXBDMALaXLhpklVoSn+8uCgws5AjkC+fynym0iYo=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
