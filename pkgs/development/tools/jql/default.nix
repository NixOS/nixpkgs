{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kYAVgQa5NAfZ7EVzO/3fW3A5Zl8uaFXguvxBco8DfRY=";
  };

  cargoSha256 = "sha256-Mz+1A7Wg7sh0pxg7umRym3UkXsMkRE0AQDTkt+e7l+s=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
