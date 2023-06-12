{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "6.0.9";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-2CCbDhZQpefsiHS+b9ZYY1oFcBMZqxSkNKbvhkBdL64=";
  };

  cargoHash = "sha256-Vu0QFyz+kyI28pGAArwu4bBTPieB5GjGXFCPiW/sbi4=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
  };
}
