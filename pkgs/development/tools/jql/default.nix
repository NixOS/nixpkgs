{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5QVktJpGpHzwRUN8oIFoLydnA+ELhUprcQASeGzgLG8=";
  };

  cargoSha256 = "sha256-qmLmkWFP8T886uR8kJKCqB0G5XIfk+r+kubamKryktc=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
