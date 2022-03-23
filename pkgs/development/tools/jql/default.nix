{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UC+1I87PPDuu+/A5zO2Q/Z5KbO/5jHuxsJ0r7a+uDLM=";
  };

  cargoSha256 = "sha256-0ezrcploLboYExcRzNnKj/vWgbJuBhteWi/Imlr4Wsg=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
