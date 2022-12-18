{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xCtTa2CLLhdflcjjqxiOgRRuxlIHhcHo8gsdLMVuxvQ=";
  };

  cargoSha256 = "sha256-yB9PemmX69bDkLTasroX3tTNzd13o7mu/fdSptsEMgM=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
