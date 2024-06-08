{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.1.11";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-gXxYN6WIbQNhFTCcrT6Kioo0FjbJM5gxHTjAK71LMjs=";
  };

  cargoHash = "sha256-bz8iAgdRxTQyZJsTVVwIpiC/ktas4Sv/S7PCqQ+/HDY=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
