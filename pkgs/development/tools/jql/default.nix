{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.0.6";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-gRRYUn5XQp6QHhI6+ZjXqLq7wfUZ8PiUgQSXBMu8uns=";
  };

  cargoHash = "sha256-Fv7CWCuV6LUXqDSCxE4JLdUdKyDUSBX/KybfM6VfRss=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
